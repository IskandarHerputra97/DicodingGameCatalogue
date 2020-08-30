//
//  HomeViewController.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 05/07/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import RealmSwift
import SDWebImage
import UIKit

class HomeViewController: UIViewController {
    //MARK: - PROPERTIES
    let activityIndicator = UIActivityIndicatorView()
    let searchBar = UISearchBar()
    let gameTableView = UITableView()
    let stackView = UIStackView()
    let realm = try! Realm()
    
    var alreadyFavoritedGamesName = [String]()
    
    override func viewWillAppear(_ animated: Bool) {
        let fetchLocalData = realm.objects(FavoriteGame.self)
        print("fetchLocalData: \(fetchLocalData)")
        print("fetchLocalData.count: \(fetchLocalData.count)")
        
        alreadyFavoritedGamesName.removeAll()
        
        for i in fetchLocalData {
            print(i)
            alreadyFavoritedGamesName.append(i.name ?? "")
        }
        
        print("alreadyFavoritedGames: \(alreadyFavoritedGamesName)")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()

        APIService.getGameData {
            self.gameTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Game Catalogue"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoriteBarButtonItemTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(aboutBarButtonItemTapped))
        setupSearchBar()
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
    func setupSearchBar() {
        searchBar.barStyle = .default
        searchBar.showsCancelButton = true
        searchBar.placeholder = "Search game here..."
        searchBar.delegate = self
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
        stackView.addArrangedSubview(searchBar)
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
    //MARK: - ACTIONS
    @objc func favoriteBarButtonItemTapped() {
        let favoriteGamesViewController = FavoriteGamesViewController()
        navigationController?.pushViewController(favoriteGamesViewController, animated: true)
    }
    @objc func aboutBarButtonItemTapped() {
        let aboutViewController = AboutViewController()
        navigationController?.pushViewController(aboutViewController, animated: true)
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        APIService.games.removeAll()
        guard let searchKey = searchBar.text else {return}
        let formattedSearchKey = searchKey.replacingOccurrences(of: " ", with: "-")
        DispatchQueue.main.async {
            self.gameTableView.reloadData()
            self.activityIndicator.startAnimating()
        }
        APIService.searchGameData(searchKey: formattedSearchKey) {
            self.gameTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return APIService.gameCount
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameTableViewCell
        guard APIService.games.count > 0 else {return cell}
        let url = URL(string: APIService.games[0].results[indexPath.row].backgroundImage ?? "https://img.pngio.com/game-icon-png-image-free-download-searchpngcom-game-icon-png-715_715.png")
        cell.gameImageView.sd_setImage(with: url!, completed: nil)
        
        guard let gameName = APIService.games[0].results[indexPath.row].name else {return cell}
        cell.gameTitleLabel.text = gameName
        guard let gameRank = APIService.games[0].results[indexPath.row].rating else {return cell}
        cell.gameRankLabel.text = "\(gameRank)"
        guard let gameReleaseDate = APIService.games[0].results[indexPath.row].released else {return cell}
        cell.gameReleaseDateLabel.text = gameReleaseDate
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameDetailViewController = GameDetailViewController(flowType: .normalFlow, imageUrlString: APIService.games[0].results[indexPath.row].backgroundImage ?? "https://img.pngio.com/game-icon-png-image-free-download-searchpngcom-game-icon-png-715_715.png", cellPosition: indexPath.row, alreadyFavoritedGamesName: self.alreadyFavoritedGamesName)
        let url = URL(string: APIService.games[0].results[indexPath.row].backgroundImage ?? "https://img.pngio.com/game-icon-png-image-free-download-searchpngcom-game-icon-png-715_715.png")
        gameDetailViewController.gameImageView.sd_setImage(with: url!, completed: nil)
        
        gameDetailViewController.title = APIService.games[0].results[indexPath.row].name
        gameDetailViewController.gameReleaseDateLabel.text = APIService.games[0].results[indexPath.row].released
        guard let metacritic = APIService.games[0].results[indexPath.row].metacritic, let playtime = APIService.games[0].results[indexPath.row].playtime, let suggestionsCount = APIService.games[0].results[indexPath.row].suggestionsCount else {return}
        gameDetailViewController.metacriticLabel.text = "\(metacritic)"
        gameDetailViewController.playtimeLabel.text = "\(playtime)"
        gameDetailViewController.suggestionsCountLabel.text = "\(suggestionsCount)"
        guard let gameRank = APIService.games[0].results[indexPath.row].rating else {return}
        gameDetailViewController.gameRankLabel.text = "\(gameRank)"
        
        navigationController?.pushViewController(gameDetailViewController, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
