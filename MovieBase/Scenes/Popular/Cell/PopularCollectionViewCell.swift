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

class PopularCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    private var disposeBag: DisposeBag? = DisposeBag()
    
    var viewModel: PopularCellViewModeling? {
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
