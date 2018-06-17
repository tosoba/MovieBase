//
//  PopularCellViewModel.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import RxSwift
import RxCocoa

protocol MoviesContainerCellViewModeling {
    var posterImage: Observable<UIImage> { get }
    var title: String { get }
}

class MoviesContainerCellViewModel: MoviesContainerCellViewModeling {
    
    let posterImage: Observable<UIImage>
    let title: String
    
    init(network: Networking, imageUrl: String, title: String) {
        let placeholder = #imageLiteral(resourceName: "movie")
        self.posterImage = Observable.just(placeholder)
            .concat(network.image(url: imageUrl))
            .observeOn(MainScheduler.instance)
            .catchErrorJustReturn(placeholder)
        self.title = title
    }
}

