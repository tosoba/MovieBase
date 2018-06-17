//
//  MoviesContainerViewController.swift
//  MovieBase
//
//  Created by merengue on 17/06/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class MoviesContainerViewController: UIViewController, MoviesContainer {
    
    private let disposeBag = DisposeBag()
    
    var network: Networking!

    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }
    
    override func didMove(toParentViewController parent: UIViewController?) {
        bindOutput()
    }

    private func configureCollectionView() {
        moviesCollectionView.refreshControl = UIRefreshControl()
    }
    
    private func bindOutput() {
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
        
        parentVC.bind(loadTrigger: Driver.merge(viewWillAppear, pull, isNearBottomEdge),
                      cellWasSelected: moviesCollectionView.rx.itemSelected.asDriver())
    }
    
    func bind(input: MoviesContainerInput) {
        input.fetching
            .drive(moviesCollectionView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        let moviesDataSource = RxCollectionViewSectionedAnimatedDataSource<MovieSectionModel>(configureCell: { [weak self] ds, cv, ip, item in
            let cell = cv.dequeueReusableCell(withReuseIdentifier: "MoviesContainerCell", for: ip) as! MoviesContainerCollectionViewCell
            cell.viewModel = MoviesContainerCellViewModel(network: self?.network ?? Network(), imageUrl: "\(basePosterURL)\(item.posterPath ?? "")", title: item.originalTitle)
            return cell
            }, configureSupplementaryView: { _, _, _, _ in return UICollectionReusableView()})
        
        input.movies.asObservable().bind(to: moviesCollectionView.rx.items(dataSource: moviesDataSource))
            .disposed(by: disposeBag)
        
        input.showMovie.subscribe(onNext: { [weak self] (vm) in
            self?.parentVC.showMovieVC(viewModel: vm)
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
    }
}
