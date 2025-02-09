//
//  CollectionViewCell.swift
//  FirstProject
//
//  Created by Даниил on 28.01.25.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    static var identifier: String { "\(Self.self)" }

    private let myImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        myImageView.image = nil
    }
    
    func configureUI() {
        contentView.roundCorners()
        contentView.addSubview(myImageView)

        myImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with model: CustomPic) {
        myImageView.image = model.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
