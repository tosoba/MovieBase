//
//  SearchViewController.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SearchViewController: UIViewController {

    @IBOutlet weak var moviesSearchBar: UISearchBar!
    @IBOutlet weak var moviesTableView: UITableView!
    
    private let disposeBag = DisposeBag()
    
    var viewModel: SearchViewModel!
    var network: Networking!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        
        let searchText = moviesSearchBar.rx.text.orEmpty
            .throttle(2.0, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .asDriverOnErrorJustComplete()
        
        let isNearBottomEdge = moviesTableView.rx.didScroll.asDriver()
            .filter { [weak self] _ in
                guard let strongSelf = self else { return false }
                return strongSelf.moviesTableView.isNearBottomEdge() && strongSelf.moviesTableView.numberOfRows(inSection: 0) > 0
            }.mapToVoid()
        
        let input = SearchViewModel.Input(searchText: searchText, loadTrigger: isNearBottomEdge, cellWasSelected: moviesTableView.rx.itemSelected.asDriver())
        
        let moviesDataSource = RxTableViewSectionedAnimatedDataSource<MovieSectionModel>(configureCell: {[weak self] ds, tv, ip, item in
            let cell = tv.dequeueReusableCell(withIdentifier: "searchMovieCell", for: ip) as! SearchTableViewCell
            cell.viewModel = SearchCellViewModel(network: self?.network ?? Network(), imageUrl: "\(basePosterURL)\(item.posterPath ?? "")", title: item.originalTitle, releaseDate: item.releaseDate, rating: String(item.voteAverage))
            return cell
        })
        
        let output = viewModel.transform(input: input)
        
        output.movies.asObservable().bind(to: moviesTableView.rx.items(dataSource: moviesDataSource)).disposed(by: disposeBag)
    }
}
