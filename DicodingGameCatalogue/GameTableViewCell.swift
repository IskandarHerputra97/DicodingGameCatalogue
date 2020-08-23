//
//  GameTableViewCell.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 05/07/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    var gameImageView = UIImageView()
    var gameTitleLabel = UILabel()
    var gameReleaseDateLabel = UILabel()
    var gameRankLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(gameImageView)
        addSubview(gameTitleLabel)
        addSubview(gameReleaseDateLabel)
        addSubview(gameRankLabel)
        
        configureGameImageView()
        configureGameTitleLabel()
        configureGameReleaseDateLabel()
        configureGameRankLabel()
        
        setGameImageViewConstraints()
        setGameTitleLabelConstraints()
        setGameReleaseDateLabelConstraints()
        setGameRankLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureGameImageView() {
        gameImageView.layer.cornerRadius = 20
        gameImageView.clipsToBounds = true
    }
    
    func configureGameTitleLabel() {
        gameTitleLabel.numberOfLines = 1
        gameTitleLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureGameReleaseDateLabel() {
        gameReleaseDateLabel.numberOfLines = 0
        gameReleaseDateLabel.adjustsFontSizeToFitWidth = true
    }
    
    func configureGameRankLabel() {
        gameRankLabel.numberOfLines = 1
        gameRankLabel.adjustsFontSizeToFitWidth = true
    }
    
    func setGameImageViewConstraints() {
        gameImageView.translatesAutoresizingMaskIntoConstraints = false
        gameImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gameImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        gameImageView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        gameImageView.widthAnchor.constraint(equalTo: gameImageView.heightAnchor, multiplier: 16/9).isActive = true
    }
    
    func setGameTitleLabelConstraints() {
        gameTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        gameTitleLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 20).isActive = true
        gameTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        gameTitleLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        gameTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
    }
    
    func setGameReleaseDateLabelConstraints() {
        gameReleaseDateLabel.translatesAutoresizingMaskIntoConstraints = false
        gameReleaseDateLabel.leadingAnchor.constraint(equalTo: gameImageView.trailingAnchor, constant: 20).isActive = true
        gameReleaseDateLabel.topAnchor.constraint(equalTo: gameTitleLabel.bottomAnchor).isActive = true
    }
    
    func setGameRankLabelConstraints() {
        gameRankLabel.translatesAutoresizingMaskIntoConstraints = false
        gameRankLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        gameRankLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
    }
}
