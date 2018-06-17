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
    
    @IBAction func toggleFavourite(_ sender: UIBarButtonItem) {
        if viewModel.movieAddedToFavourites {
            viewModel.removeFromFavourites()
            addToFavouritesButton.image = #imageLiteral(resourceName: "favourite")
        } else {
            viewModel.addToFavourites()
            addToFavouritesButton.image = #imageLiteral(resourceName: "remove")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureFavouriteBtn()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setFavouriteBtnIcon()
    }
    
    private func configureFavouriteBtn() {
        navigationItem.rightBarButtonItem = addToFavouritesButton
    }
    
    private func setFavouriteBtnIcon() {
        if viewModel.movieAddedToFavourites {
            addToFavouritesButton.image = #imageLiteral(resourceName: "remove")
        } else {
            addToFavouritesButton.image = #imageLiteral(resourceName: "favourite")
        }
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
