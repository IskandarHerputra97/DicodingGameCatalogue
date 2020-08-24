//
//  GameDetailViewController.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 05/07/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import UIKit

class GameDetailViewController: UIViewController {

    //MARK: - PROPERTIES
    var gameImageView = UIImageView()
    var gameReleaseDateTitleLabel = UILabel()
    var gameReleaseDateLabel = UILabel()
    var gameRankTitleLabel = UILabel()
    var gameRankLabel = UILabel()
    var addGameToFavoriteButton = UIButton()
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        setupGameImageView()
        setupGameReleaseDateTitleLabel()
        setupGameRankTitleLabel()
        setupAddGameToFavoriteButton()
        setupScrollView()
        setupStackView()
    }
    
    //MARK: - SETUP UI
    func setupGameImageView() {
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        gameImageView.widthAnchor.constraint(equalToConstant: 300).isActive = true
        gameImageView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func setupGameReleaseDateTitleLabel() {
        gameReleaseDateTitleLabel.text = "GAME RELEASE DATE"
        gameReleaseDateTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    func setupGameRankTitleLabel() {
        gameRankTitleLabel.text = "GAME RANK"
        gameRankTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    func setupAddGameToFavoriteButton() {
        addGameToFavoriteButton.setTitleColor(.white, for: .normal)
        addGameToFavoriteButton.backgroundColor = .red
        addGameToFavoriteButton.setTitle("Add to Favorite", for: .normal)
        addGameToFavoriteButton.addTarget(self, action: #selector(addGameToFavoriteButtonDidTapped), for: .touchUpInside)
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        
        stackView.addArrangedSubview(gameImageView)
        stackView.setCustomSpacing(50, after: gameImageView)
        stackView.addArrangedSubview(gameReleaseDateTitleLabel)
        stackView.addArrangedSubview(gameReleaseDateLabel)
        stackView.addArrangedSubview(gameRankTitleLabel)
        stackView.addArrangedSubview(gameRankLabel)
        stackView.addArrangedSubview(addGameToFavoriteButton)
        
        setStackViewConstraints()
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(stackView)
        
        setScrollViewConstraints()
    }
    
    //MARK: - SET CONSTRAINTS
    func setScrollViewConstraints() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 35).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
    }
    
    //MARK: - ACTIONS
    @objc func addGameToFavoriteButtonDidTapped() {
        print("add this game to favorite")
        navigationController?.popViewController(animated: true)
    }
}
