//
//  UIView+Extensions.swift
//  Racing2D
//
//  Created by Даниил on 29.11.24.
//

import UIKit

// MARK: - Constants

private enum Constants {
    static let cornerRadius: CGFloat = 16
    static let offset: CGFloat = 10
    static let opacity: Float = 0.75
}

extension UIView {
    // MARK: - Methods
    
    func dropShadow() {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = Constants.opacity
        layer.shadowRadius = Constants.cornerRadius
        layer.shadowOffset = CGSize(width: Constants.offset, height: Constants.offset)
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
    }
    
    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.lightGray.cgColor, UIColor.systemGreen.cgColor, UIColor.lightGray.cgColor]
        gradient.locations = [0.2, 0.5, 0.8]
        gradient.startPoint = .zero
        gradient.endPoint = CGPoint.init(x: 1, y: 1)
        gradient.cornerRadius = layer.cornerRadius
        gradient.frame = bounds
        layer.insertSublayer(gradient, at: .zero)
    }
    
    func roundCorners() {
        layer.cornerRadius = Constants.cornerRadius
        clipsToBounds = true
    }
}
