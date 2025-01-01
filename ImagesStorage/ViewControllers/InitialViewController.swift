//
//  InitialViewController.swift
//  ImagesStorage
//
//  Created by Даниил on 1.01.25.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
}

private extension InitialViewController {
    // MARK: - Methods
    
    func configureUI() {
        view.backgroundColor = .systemBackground
    }
}
