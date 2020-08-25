//
//  HomeViewController.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 05/07/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import RealmSwift
import UIKit

class HomeViewController: UIViewController {
    //MARK: - PROPERTIES
    var gameCount = 0
    var games = [Game]()
    
    let activityIndicator = UIActivityIndicatorView()
    let searchBar = UISearchBar()
    let gameTableView = UITableView()
    let stackView = UIStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let realm = try! Realm()
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        /*
        var favoriteGame = FavoriteGame()
        favoriteGame.name = "game abc"
        try! realm.write {
            realm.add(favoriteGame)
        }
        */
        
        let fetchLocalData = realm.objects(FavoriteGame.self)
        print(fetchLocalData[0].rating_top)
        
        activityIndicator.startAnimating()
        getGameData {
            self.gameTableView.reloadData()
            self.activityIndicator.stopAnimating()
        }

        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Game Catalogue"
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Favorite", style: .plain, target: self, action: #selector(favoriteBarButtonItemTapped))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "About", style: .plain, target: self, action: #selector(aboutBarButtonItemTapped))
        
        //setupActivityIndicator()
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
        print("favorite button tapped")
        let favoriteGamesViewController = FavoriteGamesViewController()
        navigationController?.pushViewController(favoriteGamesViewController, animated: true)
    }
    
    @objc func aboutBarButtonItemTapped() {
        print("about button tapped")
        let aboutViewController = AboutViewController()
        navigationController?.pushViewController(aboutViewController, animated: true)
    }
    
    func getGameData(completion: @escaping () -> Void) {
        let urlString = "https://api.rawg.io/api/games"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
                print("error message: \(error.localizedDescription)")
            }
            guard let data = data else {return}
            
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(Game.self, from: data)
                self.games.append(result)
                self.gameCount = result.results.count
                DispatchQueue.main.async {
                    completion()
                }
            }
            catch {
                print(error)
            }
        }.resume()
    }
    
    func searchGameData(searchKey: String, completion: @escaping () -> Void) {
        let urlString = "https://api.rawg.io/api/games?search=\(searchKey)"
        let url = URL(string: urlString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            guard let data = data else {return}
                
                do {
                    self.games.removeAll()
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Game.self, from: data)
                    self.games.append(result)
                    self.gameCount = result.results.count
                    print("self.games: \(self.games)")
                    DispatchQueue.main.async {
                        completion()
                    }
                }
                catch {
                    print(error)
                }
        }.resume()
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        
        games.removeAll()
        
        guard let searchKey = searchBar.text else {return}
        print("searchKey = \(searchKey)")
        let formattedSearchKey = searchKey.replacingOccurrences(of: " ", with: "-")
        print("formattedSearchKey = \(formattedSearchKey)")
        DispatchQueue.main.async {
            self.gameTableView.reloadData()
            self.activityIndicator.startAnimating()
        }
        searchGameData(searchKey: formattedSearchKey) {
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
        return gameCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell") as! GameTableViewCell
        
        guard games.count > 0 else {return cell}
        let url = URL(string: games[0].results[indexPath.row].background_image ?? "https://img.pngio.com/game-icon-png-image-free-download-searchpngcom-game-icon-png-715_715.png")
        guard let data = try? Data(contentsOf: url!) else {return cell}
        let image = UIImage(data: data)
        
        cell.gameImageView.image = image
        guard let gameName = games[0].results[indexPath.row].name else {return cell}
        cell.gameTitleLabel.text = gameName
        guard let gameRank = games[0].results[indexPath.row].rating_top else {return cell}
        cell.gameRankLabel.text = "# \(gameRank)"
        guard let gameReleaseDate = games[0].results[indexPath.row].released else {return cell}
        cell.gameReleaseDateLabel.text = gameReleaseDate
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let gameDetailViewController = GameDetailViewController(flowType: .normalFlow)
        
        let url = URL(string: games[0].results[indexPath.row].background_image ?? "https://img.pngio.com/game-icon-png-image-free-download-searchpngcom-game-icon-png-715_715.png")
        guard let data = try? Data(contentsOf: url!) else {return}
        let image = UIImage(data: data)
        
        gameDetailViewController.title = games[0].results[indexPath.row].name
        gameDetailViewController.gameImageView.image = image
        gameDetailViewController.gameReleaseDateLabel.text = games[0].results[indexPath.row].released
        guard let gameRank = games[0].results[indexPath.row].rating_top else {return}
        gameDetailViewController.gameRankLabel.text = "\(gameRank)"
        
        navigationController?.pushViewController(gameDetailViewController, animated: true)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
