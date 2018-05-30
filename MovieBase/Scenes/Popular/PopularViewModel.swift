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
        let movies: Variable<[PopularCellViewModeling]>
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
        let movies = Variable<[PopularCellViewModeling]>([])
        
        let newMovies = input.loadTrigger.flatMapLatest { [weak self] _ in
            return self?.movieService.getPopular(fromPage: self?.currentPage ?? 1)
                .trackActivity(activityIndicator)
                .trackError(errorTracker)
                .asDriverOnErrorJustComplete()
                .map({ movieSearch -> [PopularCellViewModeling] in
                    self?.totalPages = movieSearch.totalPages
                    self?.currentPage += 1
                    
                    return movieSearch.results.map { [weak self] movie in
                        PopularCellViewModel(network: self?.network ?? Network(), imageUrl: "\(basePosterURL)\(movie.posterPath ?? "")", title: movie.originalTitle)
                    }
                }) ?? Driver.of()
        }
        
        newMovies.drive(onNext: { (cells) in
            movies.value.append(contentsOf: cells)
        }, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        let fetching = activityIndicator.asDriver()
        
        return Output(fetching: fetching, movies: movies)
    }
}

