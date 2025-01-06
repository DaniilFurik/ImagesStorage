//
//  CodeImage.swift
//  ImagesStorage
//
//  Created by Даниил on 6.01.25.
//

import UIKit

// MARK: - Constants

private enum Constants {
    static let defaultImage = "circle"
    static let hightlightedImage = "inset.filled.circle"
}

class CodeImage: UIImageView {
    // MARK: - Constructor
    
    convenience init() {
        self.init(frame: .zero)
        
        let configuration = UIImage.SymbolConfiguration(weight: .light)
        
        image = UIImage(systemName: Constants.defaultImage, withConfiguration: configuration)
        highlightedImage = UIImage(systemName: Constants.hightlightedImage, withConfiguration: configuration)
        
        //.imageView?.contentMode = .scaleAspectFit
    }
}
