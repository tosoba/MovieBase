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
        
        let input = PopularViewModel.Input(loadTrigger: Driver.merge(viewWillAppear, pull), cellWasSelected: moviesCollectionView.rx.itemSelected.asDriver())
        
        let output = viewModel.transform(input: input)
        
        output.fetching
            .drive(moviesCollectionView.refreshControl!.rx.isRefreshing)
            .disposed(by: disposeBag)
        
        output.movies.drive(moviesCollectionView.rx.items(cellIdentifier: "popularMovieCell", cellType: PopularCollectionViewCell.self)) { _, viewModel, cell in
            cell.viewModel = viewModel
        }.disposed(by: disposeBag)
    }
}

