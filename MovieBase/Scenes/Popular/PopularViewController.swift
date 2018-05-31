//
//  ViewController.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class PopularViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var viewModel: PopularViewModel!

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bindViewModel()
    }
    
    private func configureCollectionView() {
        moviesCollectionView.refreshControl = UIRefreshControl()
    }

    private func bindViewModel() {
        let viewWillAppear = rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let pull = moviesCollectionView.refreshControl!.rx
            .controlEvent(.valueChanged)
            .asDriver()
        
        let isNearBottomEdge = moviesCollectionView.rx.didScroll.asDriver()
            .filter { [weak self] _ in
                guard let strongSelf = self else { return false }
                return strongSelf.moviesCollectionView.isNearBottomEdge() && strongSelf.moviesCollectionView.numberOfItems(inSection: 0) > 0
            }.mapToVoid()
    
        let input = PopularViewModel.Input(loadTrigger: Driver.merge(viewWillAppear, pull, isNearBottomEdge),
                                           cellWasSelected: moviesCollectionView.rx.itemSelected.asDriver())
    
        let moviesDataSource = RxCollectionViewSectionedAnimatedDataSource<MovieSectionModel>(configureCell: { ds, cv, ip, item in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "popularMovieCell", for: ip) as! PopularCollectionViewCell
            cell.viewModel = PopularCellViewModel(network: Network(), imageUrl: "\(basePosterURL)\(item.posterPath ?? "")", title: item.originalTitle)
            return cell
        }, configureSupplementaryView: { _, _, _, _ in return UICollectionReusableView()})
        
        let output = viewModel.transform(input: input)
        
        output.fetching
            .drive(moviesCollectionView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.movies.asObservable().bind(to: moviesCollectionView.rx.items(dataSource: moviesDataSource))
            .disposed(by: disposeBag)
    }
}

struct MovieSectionModel {
    var data: [Movie]
}

extension MovieSectionModel: AnimatableSectionModelType {
    var items: [Movie] {
        return data
    }
    
    typealias Item = Movie
    typealias Identity = String
    
    var identity: Identity { return "" }
    
    init(original: MovieSectionModel, items: [Movie]) {
        self = original
        data = items
    }
}

extension UIScrollView {
    func isNearBottomEdge(edgeOffset: CGFloat = 20.0) -> Bool {
        return self.contentOffset.y + self.frame.size.height + edgeOffset > self.contentSize.height
    }
}
