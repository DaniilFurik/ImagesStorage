//
//  CollectionViewCell.swift
//  FirstProject
//
//  Created by Даниил on 28.01.25.
//

import UIKit

// MARK: - Constants

private enum Constants {
    static let addImage = "plus.circle.fill"
    
    static let buttonSize: CGFloat = 48
}

class InsertCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
    
    static var identifier: String { "\(Self.self)" }
    
    private let button: UIButton = {
        let configuration = UIImage.SymbolConfiguration(pointSize: Constants.buttonSize)
        
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: Constants.addImage, withConfiguration: configuration), for: .normal)
        button.tintColor = .white
        
        return button
    }()
    
    private var buttonAction: UIAction?
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        if let buttonAction {
            button.removeAction(buttonAction, for: .touchUpInside)
            self.buttonAction = nil
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension InsertCollectionViewCell {
    // MARK: - Methods
    
    func configureUI() {
        contentView.roundCorners()
        contentView.backgroundColor = .systemGray

        contentView.addSubview(button)
        
        button.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configure(with action: (() -> Void)?) {
        if let action {
            buttonAction = UIAction(handler: { _ in
                action()
            })
        }
        
        if let buttonAction {
            button.addAction(buttonAction, for: .touchUpInside)
        }
    }
}
