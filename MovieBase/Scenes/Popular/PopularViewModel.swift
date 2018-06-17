//
//  PopularViewModel.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class PopularViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let cellWasSelected: Driver<IndexPath>
    }
    
    struct Output: MoviesContainerInput {
        var fetching: Driver<Bool>
        var movies: Variable<[MovieSectionModel]>
        var showMovie: Observable<MovieViewModel>
    }
    
    private let network: Networking
    private let movieService: MovieServicing

    private let disposeBag = DisposeBag()
    
    init(network: Networking, movieService: MovieServicing) {
        self.network = network
        self.movieService = movieService
    }
    
    private var currentPage = 1
    private var totalPages = 1
    
    func transform(input: PopularViewModel.Input) -> PopularViewModel.Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let movies = Variable<[MovieSectionModel]>([MovieSectionModel(data: [])])
        
        let newMovies = input.loadTrigger.flatMapLatest { [weak self] _ in
            return self?.movieService.getPopular(fromPage: self?.currentPage ?? 1)
                .trackWithAsDriver(activityIndicator: activityIndicator, errorTracker: errorTracker)
                .map({ movieSearch -> [Movie] in
                    self?.totalPages = movieSearch.totalPages
                    self?.currentPage += 1
                    
                    return movieSearch.results
                }) ?? Driver.of()
        }
        
        newMovies.drive(onNext: { (items) in
            movies.value[0].data.append(contentsOf: items)
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        let fetching = activityIndicator.asDriver()
        
        let showMovie = input.cellWasSelected.asObservable().map { [weak self] (ip) -> MovieViewModel in
            MovieViewModel(movie: movies.value[0].data[ip.row], network: self?.network ?? Network())
        }
        
        return Output(fetching: fetching, movies: movies, showMovie: showMovie)
    }
}

