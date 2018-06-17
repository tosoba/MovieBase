//
//  FavouritesViewModel.swift
//  MovieBase
//
//  Created by merengue on 17/06/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxCoreData

final class FavouriteViewModel: ViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let cellWasSelected: Driver<IndexPath>
    }
    
    struct Output: MoviesContainerInput {
        var fetching: Driver<Bool>
        var movies: Variable<[MovieSectionModel]>
        var showMovie: Observable<MovieViewModel>
    }
    
    private let disposeBag = DisposeBag()
    
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func transform(input: FavouriteViewModel.Input) -> FavouriteViewModel.Output {
        let activityIndicator = ActivityIndicator()
        let errorTracker = ErrorTracker()
        let movies = Variable<[MovieSectionModel]>([MovieSectionModel(data: [])])
        
        input.loadTrigger
            .flatMapLatest { _ in
                return persistentContainer.viewContext.rx.entities(Movie.self, sortDescriptors: [NSSortDescriptor(key: "title", ascending: false)])
                    .trackWithAsDriver(activityIndicator: activityIndicator, errorTracker: errorTracker)
            }
            .drive(onNext: { (m) in
                movies.value[0].data = m
            }, onCompleted: nil, onDisposed: nil)
            .disposed(by: disposeBag)
        
        let fetching = activityIndicator.asDriver()
        
        let showMovie = input.cellWasSelected.asObservable().map { [weak self] (ip) -> MovieViewModel in
            MovieViewModel(movie: movies.value[0].data[ip.row], network: self?.network ?? Network())
        }
        
        return Output(fetching: fetching, movies: movies, showMovie: showMovie)
    }
        
}

