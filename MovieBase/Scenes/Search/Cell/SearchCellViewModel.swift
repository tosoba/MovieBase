//
//  SearchCellViewModel.swift
//  MovieBase
//
//  Created by merengue on 31/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import RxSwift
import RxCocoa

protocol SearchCellViewModeling {
    var posterImage: Observable<UIImage> { get }
    var title: String { get }
    var releaseDate: String { get }
    var rating: String { get }
}

class SearchCellViewModel: SearchCellViewModeling {
    let posterImage: Observable<UIImage>
    let title: String
    let releaseDate: String
    let rating: String
    
    init(network: Networking, imageUrl: String, title: String, releaseDate: String, rating: String) {
        let placeholder = #imageLiteral(resourceName: "movie")
        self.posterImage = Observable.just(placeholder)
            .concat(network.image(url: imageUrl))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(placeholder)
        self.title = title
        self.releaseDate = releaseDate
        self.rating = rating
    }
}
