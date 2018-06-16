//
//  SearchTableViewCell.swift
//  MovieBase
//
//  Created by merengue on 31/05/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class SearchTableViewCell: UITableViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    private var disposeBag: DisposeBag? = DisposeBag()
    
    var viewModel: SearchCellViewModeling? {
        didSet {
            let disposeBag = DisposeBag()
            
            guard let viewModel = viewModel else { return }
            
            viewModel.posterImage
                .bind(to: posterImageView.rx.image)
                .disposed(by: disposeBag)
            
            titleLabel.text = viewModel.title
            releaseDateLabel.text = viewModel.releaseDate
            ratingLabel.text = viewModel.rating
            
            self.disposeBag = disposeBag
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        viewModel = nil
        disposeBag = nil
    }
}
