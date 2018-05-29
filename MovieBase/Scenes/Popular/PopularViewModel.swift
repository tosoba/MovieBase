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
    
    struct Output {
        let fetching: Driver<Bool>
        let movies: Driver<[PopularCellViewModeling]>
    }
    
    private let network: Networking
    private let movieService: MovieServicing
    
    init(network: Networking, movieService: MovieServicing) {
        self.network = network
        self.movieService = movieService
    }
    
    func transform(input: PopularViewModel.Input) -> PopularViewModel.Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        
        let movies = input.loadTrigger.flatMapLatest { [weak self] _ in
            return self?.movieService.getPopular()
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map({ (movieSearch) -> [PopularCellViewModeling] in
                    return movieSearch.results.map { [weak self] movie in
                        PopularCellViewModel(network: self?.network ?? Network(), imageUrl: "\(basePosterURL)\(movie.posterPath ?? "")", title: movie.originalTitle)
                    }
                }) ?? Driver.of()
        }
        
        let fetching = activityIndicator.asDriver()
        
        return Output(fetching: fetching, movies: movies)
    }
}

