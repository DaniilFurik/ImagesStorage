//
//  MainViewController.swift
//  ImagesStorage
//
//  Created by Даниил on 6.01.25.
//

import UIKit
import SnapKit

// MARK: - Constants

private enum Constants {
    static let addImage = "plus.circle"
    static let navigationImage = "n.circle"
    
    static let buttonSize: CGFloat = 100
    static let spacing: CGFloat = 48
}
class MainViewController: UIViewController {
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
}

private extension MainViewController {
    // MARK: - Methods
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        let addImageButton = UIButton(type: .system)
        addImageButton.setBackgroundImage(UIImage(systemName: Constants.addImage), for: .normal)
        addImageButton.addAction(UIAction(handler: { _ in
            self.navigationController?.pushViewController(AddImageViewController(), animated: true)
        }), for: .touchUpInside)
        view.addSubview(addImageButton)
        
        addImageButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(Constants.spacing)
            make.left.equalToSuperview().offset(Constants.spacing)
            make.width.height.equalTo(Constants.buttonSize)
        }
        
        let navigationButton = UIButton(type: .system)
        navigationButton.setBackgroundImage(UIImage(systemName: Constants.navigationImage), for: .normal)
        navigationButton.addAction(UIAction(handler: { _ in
            //self.navigationController?.pushViewController(AddImageViewController(), animated: true)
        }), for: .touchUpInside)
        view.addSubview(navigationButton)
        
        navigationButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(Constants.spacing)
            make.right.equalToSuperview().inset(Constants.spacing)
            make.width.height.equalTo(Constants.buttonSize)
        }
    }
}
