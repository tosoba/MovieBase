//
//  Movie.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Himotoki
import RxDataSources
import CoreData
import RxCoreData

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
    
    var genreIdsString: String {
        return genreIds.map { String($0) }.joined(separator: ",")
    }
}

extension Movie: Himotoki.Decodable {
    static func decode(_ e: Extractor) throws -> Movie {
        return try Movie(
            posterPath: e <| "poster_path",
            adult: e <| "adult",
            overview: e <| "overview",
            releaseDate: e <| "release_date",
            genreIds: e <| "genre_ids",
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
    var identity: String {
        return String(id)
    }
    
    typealias Identity = String
}

extension Movie: Persistable {
    
    typealias T = NSManagedObject
    
    static var entityName: String {
        return "Movie"
    }
    
    static var primaryAttributeName: String {
        return "id"
    }
    
    init(entity: NSManagedObject) {
        posterPath = entity.value(forKey: "posterPath") as? String
        adult = entity.value(forKey: "adult") as! Bool
        overview = entity.value(forKey: "overview") as! String
        releaseDate = entity.value(forKey: "releaseDate") as! String
        genreIds = (entity.value(forKey: "genreIds") as! String).split(separator: ",").map { Int($0)! }
        id = entity.value(forKey: "id") as! Int
        originalTitle = entity.value(forKey: "originalTitle") as! String
        originalLanguage = entity.value(forKey: "originalLanguage") as! String
        title = entity.value(forKey: "title") as! String
        popularity = entity.value(forKey: "popularity") as! Double
        voteCount = entity.value(forKey: "voteCount") as! Int
        voteAverage = entity.value(forKey: "voteAverage") as! Double
    }
    
    func update(_ entity: NSManagedObject) {
        entity.setValue(posterPath, forKey: "posterPath")
        entity.setValue(adult, forKey: "adult")
        entity.setValue(overview, forKey: "overview")
        entity.setValue(releaseDate, forKey: "releaseDate")
        entity.setValue(genreIdsString, forKey: "genreIds")
        entity.setValue(id, forKey: "id")
        entity.setValue(originalTitle, forKey: "originalTitle")
        entity.setValue(originalLanguage, forKey: "originalLanguage")
        entity.setValue(title, forKey: "title")
        entity.setValue(popularity, forKey: "popularity")
        entity.setValue(voteCount, forKey: "voteCount")
        entity.setValue(voteAverage, forKey: "voteAverage")
        
        do {
            try entity.managedObjectContext?.save()
        } catch let e {
            print(e)
        }
    }
}

