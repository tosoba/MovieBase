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

class PopularViewController: UIViewController, MoviesContainerParent {
    var moviesContainerVC: MoviesContainerViewController?
    
    private static let showMovieSegueId = "ShowPopularMovieSegue"
    
    private let disposeBag = DisposeBag()
    
    var viewModel: PopularViewModel!
    private var currentMovieViewModel: MovieViewModel?
    
    var network: Networking!
    
    func bind(loadTrigger: Driver<Void>, cellWasSelected: Driver<IndexPath>) {
        let input = PopularViewModel.Input(loadTrigger: loadTrigger, cellWasSelected: cellWasSelected)
        let output = viewModel.transform(input: input)
        moviesContainerVC?.bind(input: output)
    }
    
    func showMovieVC(viewModel: MovieViewModel) {
        self.currentMovieViewModel = viewModel
        self.performSegue(withIdentifier: PopularViewController.showMovieSegueId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PopularViewController.showMovieSegueId {
            let controller = segue.destination as! MovieViewController
            controller.viewModel = self.currentMovieViewModel
            controller.network = self.network
        } else {
            if let moviesContainer = segue.destination as? MoviesContainerViewController {
                self.moviesContainerVC = moviesContainer
                moviesContainer.network = self.network
            }
        }
    }
}
