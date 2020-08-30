//
//  APIService.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 30/08/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import Foundation

class APIService {
    static var games = [Game]()
    static var gameCount = 0
    
    static func getGameData(completion: @escaping () -> Void) {
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
    
    static func searchGameData(searchKey: String, completion: @escaping () -> Void) {
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
