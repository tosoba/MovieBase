//
//  MoviesContainerParent.swift
//  MovieBase
//
//  Created by merengue on 17/06/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import Foundation
import RxSwift
import RxCocoa

protocol MoviesContainerParent {
    var moviesContainerVC: MoviesContainerViewController? { get set }
    func bind(loadTrigger: Driver<Void>, cellWasSelected: Driver<IndexPath>)
    func showMovieVC(viewModel: MovieViewModel)
}

protocol MoviesContainer {
    func bind(input: MoviesContainerInput)
    var parentVC: MoviesContainerParent { get }
}

protocol MoviesContainerInput {
    var fetching: Driver<Bool> { get set }
    var movies: Variable<[MovieSectionModel]> { get set }
    var showMovie: Observable<MovieViewModel> { get set }
}

extension MoviesContainer where Self: UIViewController {
    var parentVC: MoviesContainerParent {
        return self.parent as! MoviesContainerParent
    }
}
