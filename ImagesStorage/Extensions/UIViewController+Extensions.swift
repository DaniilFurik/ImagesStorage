//
//  UIViewController+Extensions.swift
//  Racing2D
//
//  Created by Даниил on 25.12.24.
//

import UIKit

extension UIViewController {
    func showPhotoPicker(with source: UIImagePickerController.SourceType, delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) {
        guard UIImagePickerController.isSourceTypeAvailable(source) else { return }
        
        let picker = UIImagePickerController()
        picker.delegate = delegate
        //picker.allowsEditing = true
        picker.sourceType = source
        present(picker, animated: true)
    }
}
