//
//  MainViewController.swift
//  ImagesStorage
//
//  Created by Даниил on 6.01.25.
//

import UIKit

class MainViewController: UIViewController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

extension MainViewController {
    // MARK: - Methods
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}
