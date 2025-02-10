//
//  CollectionViewCell.swift
//  FirstProject
//
//  Created by Даниил on 28.01.25.
//

import UIKit

// MARK: - Constants

private enum Constants {
    static let favoriteImage = "heart.fill"
}

class CollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static var identifier: String { "\(Self.self)" }
    
    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let favoriteImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: Constants.favoriteImage)
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        myImageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CollectionViewCell {
    // MARK: - Methods
    
    func configureUI() {
        contentView.roundCorners()
        contentView.addSubview(myImageView)
        
        myImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.addSubview(favoriteImageView)

        favoriteImageView.snp.makeConstraints { make in
            make.width.height.equalToSuperview().dividedBy(5)
            make.right.bottom.equalToSuperview().inset(contentView.frame.width / 15)
        }
    }
    
    func configure(with model: CustomPic) {
        myImageView.image = model.image
        favoriteImageView.isHidden = !model.info.isFavorite
    }
}
