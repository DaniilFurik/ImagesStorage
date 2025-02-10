//
//  GlobalConstants.swift
//  Racing2D
//
//  Created by Даниил on 25.11.24.
//

import UIKit

extension String {
    static let empty = String()
    
    static let keyPassword = "KeyPassword"
    static let keyCustomPicsList = "KeyCustomImagesList"
}

final class GlobalConstants {
    static let defaultImage = UIImage(systemName: GlobalConstants.plusImage)
    
    static let verticalSpacing: CGFloat = 8
    static let horizontalSpacing: CGFloat = 16
    static let spacing: CGFloat = 48
    static let fontSize: CGFloat = 20
    
    static let higlightedPostfix = ".fill"
    
    static let dateFormat = "dd MMM yyyy HH'h' mm'm' ss's'"
    
    static let backImage = "chevron.left"
    static let favoriteImage = "heart"
    static let cameraImage = "camera"
    static let libraryImage = "photo"
    static let plusImage = "plus.circle"
    
    static let menuTitle = "Select photo source"
    static let cameraTitle = "Camera"
    static let libraryTitle = "Photo Library"
    
    static let placeholder = "Enter your note"
}
