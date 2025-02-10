//
//  EditImageViewController.swift
//  ImagesStorage
//
//  Created by Даниил on 9.01.25.
//

import UIKit

// MARK: - Constants

private enum Constants {
    static let animationDuration: TimeInterval = 0.3
    
    static let arrowLeftImage = "arrow.left.circle"
    static let arrowRightImage = "arrow.right.circle"
    
    static let buttonSize: CGFloat = 48
    
    static let picOutOfText = "pic out of"
    static let picsText = "pics"
}

class EditImageViewController: UIViewController {
    // MARK: - Properties
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textAlignment = .center
        label.font = .systemFont(ofSize: GlobalConstants.fontSize)
        return label
    }()
    
    private lazy var imageContainerView: ImageContainerView = {
        let view = ImageContainerView()
        view.delegate = self
        return view
    }()
    
    private let leftButton: UIButton  = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: Constants.arrowLeftImage), for: .normal)
        return button
    }()
    
    private let rightButton: UIButton  = {
        let button = UIButton(type: .system)
        button.setBackgroundImage(UIImage(systemName: Constants.arrowRightImage), for: .normal)
        return button
    }()
    
    private var customPics = [CustomPic]()
    private var currentIndex: Int = .zero
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
}

private extension EditImageViewController {
    // MARK: - Methods

    func configureUI() {
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
 
        let bottomView = UIView()
        containerView.addSubview(bottomView)

        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(imageContainerView)
            make.top.equalTo(imageContainerView.snp.bottom).offset(GlobalConstants.spacing)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        leftButton.addAction(UIAction(handler: { _ in
            self.leftPressed()
        }), for: .touchUpInside)
        bottomView.addSubview(leftButton)
        
        leftButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(GlobalConstants.horizontalSpacing)
            make.width.height.equalTo(Constants.buttonSize)
        }
        
        rightButton.addAction(UIAction(handler: { _ in
            self.rightPressed()
        }), for: .touchUpInside)
        bottomView.addSubview(rightButton)
        
        rightButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(GlobalConstants.horizontalSpacing)
            make.width.height.equalTo(Constants.buttonSize)
        }
        
        bottomView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(leftButton.snp.right).offset(GlobalConstants.horizontalSpacing)
            make.right.equalTo(rightButton.snp.left).offset(-GlobalConstants.horizontalSpacing)
        }
    }
    
    func animateTempImage(fromX: CGFloat, toX: CGFloat, image: UIImage) {
        lockButtons(isEnabled: false)
        
        let tempImageView = UIImageView(image: image)
        tempImageView.backgroundColor = .systemBackground
        tempImageView.contentMode = .scaleAspectFit
        view.addSubview(tempImageView)

        let imageViewFrame = imageContainerView.getImageViewFrame()
        
        tempImageView.frame = CGRect(
            x: fromX,
            y: imageViewFrame.origin.y,
            width: imageViewFrame.width,
            height: imageViewFrame.height
        )

        UIView.animate(withDuration: Constants.animationDuration) {
            tempImageView.frame.origin.x = toX
        } completion: { [self] _ in
            lockButtons(isEnabled: true)
            tempImageView.removeFromSuperview()

            // если анимация была спарва
            if toX == .zero {
                imageContainerView.initCustomImage(from: customPics[currentIndex])
            }
        }
    }
    
    func lockButtons(isEnabled: Bool) {
        rightButton.isUserInteractionEnabled = isEnabled
        leftButton.isUserInteractionEnabled = isEnabled
    }
    
    func leftPressed() {
        let image = customPics[currentIndex].image
        animateTempImage(fromX: .zero, toX: -view.frame.width, image: image)
        
        prepareForNewImage(isNext: false)
        
        imageContainerView.initCustomImage(from: customPics[currentIndex])
    }
    
    func rightPressed() {
        prepareForNewImage(isNext: true)
        
        let image = customPics[currentIndex].image
        animateTempImage(fromX: view.frame.width, toX: .zero, image: image)
    }
    
    func prepareForNewImage(isNext: Bool) {
        if let customImage = imageContainerView.getCustomImageForSaving() {
            customPics[currentIndex] = customImage
        }
        
        calculateCurrentIndex(isNext: isNext)
        infoLabel.text = "\(currentIndex + 1) \(Constants.picOutOfText) \(customPics.count) \(Constants.picsText)"
    }
    
    func calculateCurrentIndex(isNext: Bool) {
        if isNext {
            if currentIndex == customPics.count - 1 {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        } else {
            if currentIndex == 0 {
                currentIndex = customPics.count - 1
            } else {
                currentIndex -= 1
            }
        }
    }

    @objc private func didTap() {
        view.endEditing(true)
    }
}

extension EditImageViewController {
    func initData(images: [CustomPic], index: Int = .zero) {
        currentIndex = index
        customPics = images
        
        infoLabel.text = "\(currentIndex + 1) \(Constants.picOutOfText) \(customPics.count) \(Constants.picsText)"
        
        imageContainerView.initCustomImage(from: customPics[currentIndex])
    }
}

extension EditImageViewController: ImageContainerViewDelegate {
    
    func backPressed() {
        if let customImage = imageContainerView.getCustomImageForSaving() {
            customPics[currentIndex] = customImage
        }
        
        navigationController?.popViewController(animated: true)
        
        StorageManager.shared.saveCustomPics(customPics: customPics)
    }
    
    func showPicker(with source: UIImagePickerController.SourceType, delegate: (any UIImagePickerControllerDelegate & UINavigationControllerDelegate)) {
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
}
