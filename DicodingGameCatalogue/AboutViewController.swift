//
//  AboutViewController.swift
//  DicodingGameCatalogue
//
//  Created by Iskandar Herputra Wahidiyat on 05/07/20.
//  Copyright © 2020 Iskandar Herputra Wahidiyat. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    //MARK: - PROPERTIES
    let aboutImageView = UIImageView()
    let nameLabel = UILabel()
    let stackView = UIStackView()
    let scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        title = "About Page"
        view.backgroundColor = .black
        setupAboutImageView()
        setupNameLabel()
        setupScrollView()
        setupStackView()
    }
    //MARK: - SETUP UI
    func setupAboutImageView() {
        aboutImageView.image = UIImage(named: "profile-photo")
    }
    func setupNameLabel() {
        nameLabel.text = "Iskandar Herputra Wahidiyat"
        nameLabel.textColor = .white
    }
    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.alignment = .center
        stackView.addArrangedSubview(aboutImageView)
        stackView.addArrangedSubview(nameLabel)
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
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
}
