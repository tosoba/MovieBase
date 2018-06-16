//
//  MovieSectionModel.swift
//  MovieBase
//
//  Created by merengue on 31/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation
import RxDataSources

struct MovieSectionModel {
    var data: [Movie]
}

extension MovieSectionModel: AnimatableSectionModelType {
    var items: [Movie] {
        return data
    }
    
    typealias Item = Movie
    typealias Identity = String
    
    var identity: Identity { return "" }
    
    init(original: MovieSectionModel, items: [Movie]) {
        self = original
        data = items
    }
}
