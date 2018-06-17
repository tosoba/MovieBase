//
//  FavouritesViewController.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FavouritesViewController: UIViewController, MoviesContainerParent {
    
    @IBOutlet weak var noFavouritesLabel: UILabel!
    
    var viewModel: FavouriteViewModel!
    var network: Networking!
    
    private var currentMovieViewModel: MovieViewModel?
    
    var moviesContainerVC: MoviesContainerViewController?
    
    private let disposeBag = DisposeBag()
    
    func bind(loadTrigger: Driver<Void>, cellWasSelected: Driver<IndexPath>) {
        let input = FavouriteViewModel.Input(loadTrigger: loadTrigger, cellWasSelected: cellWasSelected)
        let output = viewModel.transform(input: input)
        
        output.movies.asDriver()
            .map { (sectionModels) -> Bool in
                !sectionModels[0].data.isEmpty
            }
            .drive(noFavouritesLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        moviesContainerVC?.bind(input: output)
    }
    
    private static let showMovieSegueId = "ShowFavouriteMovieSegue"
    
    func showMovieVC(viewModel: MovieViewModel) {
        self.currentMovieViewModel = viewModel
        self.performSegue(withIdentifier: FavouritesViewController.showMovieSegueId, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == FavouritesViewController.showMovieSegueId {
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
