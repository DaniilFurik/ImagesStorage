//
//  AddImageViewController.swift
//  ImagesStorage
//
//  Created by Даниил on 7.01.25.
//

import UIKit

class AddImageViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var imageContainerView: ImageContainerView = {
        let view = ImageContainerView()
        view.delegate = self
        return view
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
}

extension AddImageViewController: ImageContainerViewDelegate {
    // MARK: - Methods
    
    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        let containerView = UIView()
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
                
        containerView.addSubview(imageContainerView)
        
        imageContainerView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
    
    func showPicker(with source: UIImagePickerController.SourceType, delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)) {
        showPhotoPicker(with: source, delegate: delegate)
    }
    
    func editConstraints(offset: CGFloat, duration: TimeInterval) {
        guard let superview = imageContainerView.superview else { return }
        
        superview.snp.updateConstraints { make in
            make.bottom.top.equalTo(view.safeAreaLayoutGuide).offset(offset)
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func backPressed() {
        if let customImage = imageContainerView.getCustomImageForSaving() {
            // если добавлили картинку, то сохраняем и идем на список всех картинок
            StorageManager.shared.saveCustomImage(customImage: customImage)
            
            let controller = EditImageViewController()
            
            let customPics = StorageManager.shared.getCustomPics()
            controller.initData(images: customPics)
            
            navigationController?.pushViewController(controller, animated: false)
            removeFromParent()
        } else {
            // если не добавлили картинку, то идем назад
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func didTap() {
        view.endEditing(true)
    }
}
