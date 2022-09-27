//
//  MovieSearch.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Himotoki

struct MovieSearch {
    let page: Int
    let results: [Movie]
    let totalResults: Int
    let totalPages: Int
}

extension MovieSearch: Himotoki.Decodable {
    static func decode(_ e: Extractor) throws -> MovieSearch {
        return try MovieSearch(
            page: e <| "page",
            results: e <| "results",
            totalResults: e <| "total_results",
            totalPages: e <| "total_pages"
        )
    }
}

