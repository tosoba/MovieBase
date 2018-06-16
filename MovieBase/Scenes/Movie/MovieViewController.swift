//
//  MovieViewController.swift
//  MovieBase
//
//  Created by merengue on 16/06/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MovieViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    var viewModel: MovieViewModel!
    
    var network: Networking!

    @IBOutlet weak var addToFavouritesButton: UIBarButtonItem!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var overviewText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = addToFavouritesButton
        bindViewModel()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let sizeFittingTextView = overviewText.sizeThatFits(CGSize(width: overviewText.frame.size.width, height: CGFloat(MAXFLOAT)))
        overviewText.heightAnchor.constraint(equalToConstant: sizeFittingTextView.height)

    }
    
    private func bindViewModel() {
        let input = MovieViewModel.Input(favouriteButtonWasPressed: addToFavouritesButton.rx.tap.asDriver())
        
        let output = viewModel.transform(input: input)
        output.posterImage.bind(to: posterImage.rx.image)
            .disposed(by: disposeBag)
        
        titleLabel.text = viewModel.movie.title
        releaseDateLabel.text = viewModel.movie.releaseDate
        ratingLabel.text = String(viewModel.movie.voteAverage)
        overviewText.text = viewModel.movie.overview
    }
}
