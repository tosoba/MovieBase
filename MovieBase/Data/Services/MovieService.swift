//
//  MovieService.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxSwift

fileprivate let baseURL = "https://api.themoviedb.org/3/"
let basePosterURL = "https://image.tmdb.org/t/p/w342"

enum MovieDb {
    case popular
    
    var url: String {
        switch self {
        case .popular:
            return "\(baseURL)movie/popular?api_key=\(movieDbAPIKey)"
        }
    }
}

protocol MovieServicing {
    func getPopular() -> Observable<MovieSearch>
}

class MovieService: MovieServicing {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func getPopular() -> Observable<MovieSearch> {
        let url = MovieDb.popular.url
        return network.request(method: .get, url: url, parameters: nil, type: MovieSearch.self)
    }
}

