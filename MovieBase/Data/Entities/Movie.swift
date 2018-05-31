//
//  Movie.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Himotoki
import RxDataSources

struct Movie {
    let posterPath: String?
    let adult: Bool
    let overview: String
    let releaseDate: String
    let genreIds: [Int]
    let id: Int
    let originalTitle: String
    let originalLanguage: String
    let title: String
    let popularity: Double
    let voteCount: Int
    let voteAverage: Double
}

extension Movie: Himotoki.Decodable {
    static func decode(_ e: Extractor) throws -> Movie {
        return try Movie(
            posterPath: e <| "poster_path",
            adult: e <| "adult",
            overview: e <| "overview",
            releaseDate: e <| "release_date",
            genreIds: e <|| "genre_ids",
            id: e <| "id",
            originalTitle: e <| "original_title",
            originalLanguage: e <| "original_language",
            title: e <| "title",
            popularity: e <| "popularity",
            voteCount: e <| "vote_count",
            voteAverage: e <| "vote_average"
        )
    }
}

extension Movie: Equatable {
    static func ==(lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Movie: IdentifiableType {
    var identity: Int {
        return id
    }
    
    typealias Identity = Int
}
