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
    static let countInLine: CGFloat = 3
    static let titleFontSize: CGFloat = 24
    
    static let titleText = "My Gallery"
}

class MainViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true

        collectionView.register(InsertCollectionViewCell.self, forCellWithReuseIdentifier: InsertCollectionViewCell.identifier)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var customPics = [CustomPic]()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        StorageManager.shared.getCustomPics { [weak self] pics in
            self?.customPics = pics
            self?.collectionView.reloadData()
        }
    }
}

private extension MainViewController {
    // MARK: - Private Methods
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        let titleLabel = UILabel()
        titleLabel.text = Constants.titleText
        titleLabel.font = .systemFont(ofSize: Constants.titleFontSize, weight: .semibold)
        view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        collectionView.contentInset = .init(
            top: GlobalConstants.horizontalSpacing,
            left: GlobalConstants.horizontalSpacing,
            bottom: .zero,
            right: GlobalConstants.horizontalSpacing
        )
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    // MARK: - Methods
    
    func initData(customPics: [CustomPic]) {
        self.customPics = customPics
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return customPics.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == customPics.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InsertCollectionViewCell.identifier, for: indexPath) as? InsertCollectionViewCell else {
                return UICollectionViewCell()
            }
    
            cell.configure(with: {
                let controller = AddImageViewController()
                controller.initData(customPics: self.customPics)
                self.navigationController?.pushViewController(controller, animated: true)
            })
            
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
                return UICollectionViewCell()
            }
            
            cell.configure(with: customPics[indexPath.row])
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size =
        ((collectionView.frame.width - collectionView.contentInset.left - collectionView.contentInset.right) -
        GlobalConstants.horizontalSpacing * (Constants.countInLine - 1)) / Constants.countInLine
        return CGSize(width: size, height: size)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return GlobalConstants.horizontalSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        if indexPath.row == customPics.count {
            return false
        }
        
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = EditImageViewController()
        controller.initData(images: customPics, index: indexPath.row)
        navigationController?.pushViewController(controller, animated: true)
    }
}
