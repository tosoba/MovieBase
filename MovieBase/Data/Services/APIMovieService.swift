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

enum MovieAPI {
    case popular(page: Int)
    case search(query: String, page: Int)
    
    var url: String {
        switch self {
        case .popular(let page):
            return "\(baseURL)movie/popular?api_key=\(movieDbAPIKey)&language=en-US&page=\(page)"
            
        case .search(let query, let page):
            return "\(baseURL)search/movie?api_key=\(movieDbAPIKey)&language=en-US&page=\(page)&query=\(query)"
        }
    }
}

protocol APIMovieServicing {
    func getPopular(fromPage page: Int) -> Observable<MovieSearch>
    func search(query: String, fromPage page: Int) -> Observable<MovieSearch>
}

class APIMovieService: APIMovieServicing {
    private let network: Networking
    
    init(network: Networking) {
        self.network = network
    }
    
    func getPopular(fromPage page: Int = 1) -> Observable<MovieSearch> {
        let url = MovieAPI.popular(page: page).url
        return network.request(method: .get, url: url, parameters: nil, type: MovieSearch.self)
    }
    
    func search(query: String, fromPage page: Int = 1) -> Observable<MovieSearch> {
        let url = MovieAPI.search(query: query, page: page).url
        return network.request(method: .get, url: url, parameters: nil, type: MovieSearch.self)
    }
}

