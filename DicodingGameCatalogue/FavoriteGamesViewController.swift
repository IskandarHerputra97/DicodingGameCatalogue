//
//  FavoriteGamesViewController.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 24/08/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import RealmSwift
import UIKit

class FavoriteGamesViewController: UIViewController {
    //MARK: - PROPERTIES
    let realm = try! Realm()
    var gameCount = 0
    var games = [FavoriteGame]()
    let activityIndicator = UIActivityIndicatorView()
    let gameTableView = UITableView()
    let stackView = UIStackView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = "Favorite Games"
        view.backgroundColor = .white
        let fetchLocalData = realm.objects(FavoriteGame.self)
        games.append(contentsOf: fetchLocalData)
        gameCount = fetchLocalData.count
        setupGameTableView()
        setupStackView()
        setupActivityIndicator()
    }
    //MARK: - SETUP UI
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.style = .large
        setActivityIndicatorConstraints()
    }
    func setupGameTableView() {
        gameTableView.dataSource = self
        gameTableView.delegate = self
        gameTableView.rowHeight = 100
        gameTableView.register(GameTableViewCell.self, forCellReuseIdentifier: "GameCell")
    }
    func setupStackView() {
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.addArrangedSubview(gameTableView)
        setStackViewConstraints()
    }
    //MARK: - SET COSNTRAINTS
    func setActivityIndicatorConstraints() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    func setStackViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
}
extension FavoriteGamesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameTableViewCell
        guard games.count > 0 else {return cell}
        let url = URL(string: games[indexPath.row].background_image ?? "https://img.pngio.com/game-icon-png-image-free-download-searchpngcom-game-icon-png-715_715.png")
        guard let data = try? Data(contentsOf: url!) else {return cell}
        let image = UIImage(data: data)
        cell.gameImageView.image = image
        guard let gameName = games[indexPath.row].name else {return cell}
        cell.gameTitleLabel.text = gameName
        guard let gameRank = games[indexPath.row].rating_top else {return cell}
        cell.gameRankLabel.text = "\(gameRank)"
        guard let gameReleaseDate = games[indexPath.row].released else {return cell}
        cell.gameReleaseDateLabel.text = gameReleaseDate
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameDetailViewController = GameDetailViewController(flowType: .favoriteFlow, imageUrlString: games[indexPath.row].background_image ?? "https://img.pngio.com/game-icon-png-image-free-download-searchpngcom-game-icon-png-715_715.png", cellPosition: indexPath.row, alreadyFavoritedGamesName: [])
        let url = URL(string: games[indexPath.row].background_image ?? "https://img.pngio.com/game-icon-png-image-free-download-searchpngcom-game-icon-png-715_715.png")
        guard let data = try? Data(contentsOf: url!) else {return}
        let image = UIImage(data: data)
        gameDetailViewController.title = games[indexPath.row].name
        gameDetailViewController.gameImageView.image = image
        gameDetailViewController.gameReleaseDateLabel.text = games[indexPath.row].released
        guard let gameRank = games[indexPath.row].rating_top else {return}
        gameDetailViewController.gameRankLabel.text = "\(gameRank)"
        navigationController?.pushViewController(gameDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
