//
//  CodeButton.swift
//  ImagesStorage
//
//  Created by Даниил on 5.01.25.
//

import UIKit

// MARK: - Constants

private enum Constants {
    static let higlightedPostfix = ".fill"
}

class CodeButton: UIButton {
    // MARK: - Constructor
    
    convenience init(imageName: String) {
        self.init()
    
        let configuration = UIImage.SymbolConfiguration(weight: .light)
        
        setBackgroundImage(UIImage(systemName: imageName, withConfiguration: configuration), for: .normal)
        setBackgroundImage(UIImage(systemName: imageName + Constants.higlightedPostfix, withConfiguration: configuration), for: .highlighted)
        
        imageView?.contentMode = .scaleAspectFit
    }
}
