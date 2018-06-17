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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    var moviesContainerVC: MoviesContainerViewController?
    
    func bind(loadTrigger: Driver<Void>, cellWasSelected: Driver<IndexPath>) {
        
    }
    
    func showMovieVC(viewModel: MovieViewModel) {
        
    }
}
