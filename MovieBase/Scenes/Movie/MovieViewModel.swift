//
//  MovieViewModel.swift
//  MovieBase
//
//  Created by merengue on 16/06/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import CoreData

final class MovieViewModel: ViewModel {
    struct Input {
        let favouriteButtonWasPressed: Driver<Void>
    }
    
    struct Output {
        let posterImage: Observable<UIImage>
    }
    
    let movie: Movie
    
    private let network: Networking
    
    init(movie: Movie, network: Networking) {
        self.movie = movie
        self.network = network
    }
    
    var movieAddedToFavourites: Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Movie")
        fetchRequest.predicate = NSPredicate(format: "id = %d", movie.id)
        
        var results: [NSManagedObject] = []
        
        do {
            results = try persistentContainer.viewContext.fetch(fetchRequest)
        } catch {
            print("error executing fetch request: \(error)")
        }
        
        return results.count > 0
    }
    
    func removeFromFavourites() {
        do {
            try persistentContainer.viewContext.rx.delete(movie)
        } catch {
            print(error)
        }
    }
    
    func addToFavourites() {
        do {
            try persistentContainer.viewContext.rx.update(movie)
        } catch {
            print(error)
        }
    }
    
    func transform(input: MovieViewModel.Input) -> MovieViewModel.Output {
        let placeholder = #imageLiteral(resourceName: "movie")
        let posterImage = Observable.just(placeholder)
            .concat(network.image(url: "\(basePosterURL)\(movie.posterPath ?? "")"))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(placeholder)
        
        return Output(posterImage: posterImage)
    }
}
