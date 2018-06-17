//
//  PopularCollectionViewCell.swift
//  MovieBase
//
//  Created by merengue on 29/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MoviesContainerCollectionViewCell: UICollectionViewCell {
    
    private var disposeBag: DisposeBag? = DisposeBag()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var viewModel: MoviesContainerCellViewModeling? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else { return }
            
            viewModel.posterImage
                .bind(to: posterImageView.rx.image)
                .disposed(by: disposeBag)
            
            titleLabel.text = viewModel.title
            
            self.disposeBag = disposeBag
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
        disposeBag = nil
    }
}
