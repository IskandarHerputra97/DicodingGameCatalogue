//
//  GameDetailViewController.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 05/07/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import RealmSwift
import UIKit

enum GameDetailViewControllerFlowType: Int {
    case normalFlow
    case favoriteFlow
}

class GameDetailViewController: UIViewController {
    //MARK: - PROPERTIES
    let realm = try! Realm()
    var gameImageView = UIImageView()
    var gameReleaseDateTitleLabel = UILabel()
    var gameReleaseDateLabel = UILabel()
    var gameRankTitleLabel = UILabel()
    var gameRankLabel = UILabel()
    var addGameToFavoriteButton = UIButton()
    var removeGameFromFavoriteButton = UIButton()
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    
    let flowType: GameDetailViewControllerFlowType
    var imageUrlString: String
    
    required init(flowType: GameDetailViewControllerFlowType, imageUrlString: String) {
        self.flowType = flowType
        self.imageUrlString = imageUrlString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        
        setupGameImageView()
        setupGameReleaseDateTitleLabel()
        setupGameRankTitleLabel()
        setupAddGameToFavoriteButton()
        setupRemoveGameFromFavoriteButton()
        setupScrollView()
        setupStackView()
        
        if self.flowType == .normalFlow {
            removeGameFromFavoriteButton.isHidden = true
            addGameToFavoriteButton.isHidden = false
        }
        else if flowType == .favoriteFlow {
            removeGameFromFavoriteButton.isHidden = false
            addGameToFavoriteButton.isHidden = true
        }
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
    
    func setupRemoveGameFromFavoriteButton() {
        removeGameFromFavoriteButton.setTitleColor(.white, for: .normal)
        removeGameFromFavoriteButton.backgroundColor = .blue
        removeGameFromFavoriteButton.setTitle("Remove from Favorite", for: .normal)
        removeGameFromFavoriteButton.addTarget(self, action: #selector(removeGameFromFavoriteButtonDidTapped), for: .touchUpInside)
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
        stackView.addArrangedSubview(removeGameFromFavoriteButton)
        
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
        
        var favoriteGame = FavoriteGame()
        favoriteGame.name = title
        favoriteGame.background_image = self.imageUrlString
        favoriteGame.released = gameReleaseDateLabel.text
        favoriteGame.rating_top = gameRankLabel.text
        try! realm.write {
            realm.add(favoriteGame)
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func removeGameFromFavoriteButtonDidTapped() {
        print("remove this game from favorite")
        navigationController?.popViewController(animated: true)
    }
}
