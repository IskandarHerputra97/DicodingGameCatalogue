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
    var metacriticTitleLabel = UILabel()
    var metacriticLabel = UILabel()
    var playtimeTitleLabel = UILabel()
    var playtimeLabel = UILabel()
    var suggestionsCountTitleLabel = UILabel()
    var suggestionsCountLabel = UILabel()
    var addGameToFavoriteButton = UIButton()
    var removeGameFromFavoriteButton = UIButton()
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    let flowType: GameDetailViewControllerFlowType
    var imageUrlString: String
    let cellPosition: Int
    
    var alreadyFavoritedGamesName = [String]()
    
    required init(flowType: GameDetailViewControllerFlowType, imageUrlString: String, cellPosition: Int, alreadyFavoritedGamesName: [String]) {
        self.flowType = flowType
        self.imageUrlString = imageUrlString
        self.cellPosition = cellPosition
        self.alreadyFavoritedGamesName = alreadyFavoritedGamesName
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        view.backgroundColor = .white
        setupGameImageView()
        setupGameReleaseDateTitleLabel()
        setupGameRankTitleLabel()
        setupMetacriticTitleLabel()
        setupPlaytimeTitleLabel()
        setupSuggestionsCountTitleLabel()
        setupAddGameToFavoriteButton()
        setupRemoveGameFromFavoriteButton()
        setupScrollView()
        setupStackView()
        if self.flowType == .normalFlow {
            if alreadyFavoritedGamesName.isEmpty {
                removeGameFromFavoriteButton.isHidden = true
                addGameToFavoriteButton.isHidden = false
            }
            else {
                for i in alreadyFavoritedGamesName {
                    print(i)
                    if i == self.title {
                        print("\(i) game favorited")
                        removeGameFromFavoriteButton.isHidden = false
                        addGameToFavoriteButton.isHidden = true
                        break
                    }
                    else {
                        print("\(i) not favorited")
                        removeGameFromFavoriteButton.isHidden = true
                        addGameToFavoriteButton.isHidden = false
                    }
                }
            }
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
    
    func setupMetacriticTitleLabel() {
        metacriticTitleLabel.text = "METACRITIC"
        metacriticTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    func setupPlaytimeTitleLabel() {
        playtimeTitleLabel.text = "PLAY TIME"
        playtimeTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
    }
    
    func setupSuggestionsCountTitleLabel() {
        suggestionsCountTitleLabel.text = "SUGGESTIONS COUNT"
        suggestionsCountTitleLabel.font = UIFont.boldSystemFont(ofSize: 24)
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
        stackView.addArrangedSubview(metacriticTitleLabel)
        stackView.addArrangedSubview(metacriticLabel)
        stackView.addArrangedSubview(playtimeTitleLabel)
        stackView.addArrangedSubview(playtimeLabel)
        stackView.addArrangedSubview(suggestionsCountTitleLabel)
        stackView.addArrangedSubview(suggestionsCountLabel)
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
        let favoriteGame = FavoriteGame()
        favoriteGame.name = title
        favoriteGame.background_image = self.imageUrlString
        favoriteGame.released = gameReleaseDateLabel.text
        favoriteGame.rating = gameRankLabel.text
        favoriteGame.metacritic = metacriticLabel.text
        favoriteGame.playtime = playtimeLabel.text
        favoriteGame.suggestions_count = suggestionsCountLabel.text
        try! realm.write {
            realm.add(favoriteGame)
        }
        navigationController?.popViewController(animated: true)
    }
    @objc func removeGameFromFavoriteButtonDidTapped() {
        var counter = 0
        let result = realm.objects(FavoriteGame.self)
        for i in result {
            if let nameFromResult = i.name, let gameTitle = self.title {
                print("nameFromResult: \(nameFromResult)")
                print("gameTitle: \(gameTitle)")
                if nameFromResult == gameTitle {
                    try! realm.write {
                        realm.delete(result[counter])
                    }
                }
            }
            counter += 1
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
