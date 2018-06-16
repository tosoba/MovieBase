//
//  SearchViewModel.swift
//  MovieBase
//
//  Created by merengue on 31/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel: ViewModel {
    struct Input {
        let searchText: Driver<String>
        let loadTrigger: Driver<Void>
        let cellWasSelected: Driver<IndexPath>
    }
    
    struct Output {
        let fetching: Driver<Bool>
        let movies: Variable<[MovieSectionModel]>
    }
    
    private let network: Networking
    private let movieService: MovieServicing
    
    private var lastQuery: String?
    
    private let disposeBag = DisposeBag()
    
    private var currentPage = 1
    private var totalPages = 1
    
    init(network: Networking, movieService: MovieServicing) {
        self.network = network
        self.movieService = movieService
    }
    
    func transform(input: SearchViewModel.Input) -> SearchViewModel.Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let movies = Variable<[MovieSectionModel]>([MovieSectionModel(data: [])])
        
        let newQueryMovies = input.searchText.flatMapLatest { [weak self] (query) -> Driver<[Movie]> in
            self?.currentPage = 1
            self?.lastQuery = query
            return self?.movieService.search(query: query, fromPage: 1)
                .trackWithAsDriver(activityIndicator: activityIndicator, errorTracker: errorTracker)
                .map({ movieSearch -> [Movie] in
                    self?.totalPages = movieSearch.totalPages
                    self?.currentPage += 1
                    
                    return movieSearch.results
                }) ?? Driver.of()
        }
        
        let lastQueryMovies = input.loadTrigger.flatMapLatest { [weak self] _ -> Driver<[Movie]> in
            let lq = self?.lastQuery
            if lq == nil {
                return Driver.of()
            } else {
                return self?.movieService.search(query: lq!, fromPage: self?.currentPage ?? 1)
                    .trackWithAsDriver(activityIndicator: activityIndicator, errorTracker: errorTracker)
                    .map({ movieSearch -> [Movie] in
                        self?.totalPages = movieSearch.totalPages
                        self?.currentPage += 1
                        
                        return movieSearch.results
                    }) ?? Driver.of()
            }
        }
        
        newQueryMovies.drive(onNext: { (items) in
            movies.value[0].data.removeAll()
            movies.value[0].data.append(contentsOf: items)
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        lastQueryMovies.drive(onNext: { (items) in
            movies.value[0].data.append(contentsOf: items)
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        let fetching = activityIndicator.asDriver()
        
        return Output(fetching: fetching, movies: movies)
    }
}
