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
        return label
    }()
    
    private lazy var imageContainerView: ImageContainerView = {
        let view = ImageContainerView()
        view.delegate = self
        return view
    }()

    private var customImages = [CustomImage]()
    private var currentIndex: Int = .zero
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        initData()
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
}

extension EditImageViewController: IImageContainerViewDelegate {
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
 
        let bottomView = UIView()
        containerView.addSubview(bottomView)

        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(imageContainerView)
            make.top.equalTo(imageContainerView.snp.bottom).offset(GlobalConstants.spacing)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        let leftButton = UIButton(type: .system)
        leftButton.setBackgroundImage(UIImage(systemName: Constants.arrowLeftImage), for: .normal)
        leftButton.addAction(UIAction(handler: { _ in
            self.leftPressed()
        }), for: .touchUpInside)
        bottomView.addSubview(leftButton)
        
        leftButton.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(GlobalConstants.horizontalSpacing)
            make.width.height.equalTo(Constants.buttonSize)
        }
        
        let rightButton = UIButton(type: .system)
        rightButton.setBackgroundImage(UIImage(systemName: Constants.arrowRightImage), for: .normal)
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
            tempImageView.removeFromSuperview()

            // если анимация была спарва
            if toX == .zero {
                imageContainerView.initCustomImage(from: customImages[currentIndex])
            }
        }
    }
    
    private func leftPressed() {
        let image = StorageManager.shared.getImage(fileName: customImages[currentIndex].imageFileName)
        animateTempImage(fromX: .zero, toX: -view.frame.width, image: image!)
        
        prepareForNewImage(isNext: false)
        
        imageContainerView.initCustomImage(from: customImages[currentIndex])
    }
    
    private func rightPressed() {
        prepareForNewImage(isNext: true)
        
        let image = StorageManager.shared.getImage(fileName: customImages[currentIndex].imageFileName)
        animateTempImage(fromX: view.frame.width, toX: .zero, image: image!)
    }
    
    private func prepareForNewImage(isNext: Bool) {
        if let customImage = imageContainerView.getCustomImageForSaving() {
            customImages[currentIndex] = customImage
        }
        
        calculateCurrentIndex(isNext: isNext)
        infoLabel.text = "\(currentIndex + 1) \(Constants.picOutOfText) \(customImages.count) \(Constants.picsText)"
    }
    
    func backPressed() {
        if let customImage = imageContainerView.getCustomImageForSaving() {
            customImages[currentIndex] = customImage
        }
        
        navigationController?.popViewController(animated: true)
        
        StorageManager.shared.saveCustomImages(customImages: customImages)
    }
    
    private func initData() {
        customImages = StorageManager.shared.getCustomImages()
        
        infoLabel.text = "\(currentIndex + 1) \(Constants.picOutOfText) \(customImages.count) \(Constants.picsText)"
        
        imageContainerView.initCustomImage(from: customImages[currentIndex])
    }
    
    private func calculateCurrentIndex(isNext: Bool) {
        if isNext {
            if currentIndex == customImages.count - 1 {
                currentIndex = 0
            } else {
                currentIndex += 1
            }
        } else {
            if currentIndex == 0 {
                currentIndex = customImages.count - 1
            } else {
                currentIndex -= 1
            }
        }
    }

    func showPicker(with source: UIImagePickerController.SourceType, delegate: (any UIImagePickerControllerDelegate & UINavigationControllerDelegate)) {
        showPhotoPicker(with: source, delegate: delegate)
    }
    
    func editConstraints(offset: CGFloat, duration: TimeInterval) {
        imageContainerView.superview!.snp.updateConstraints { make in
            make.bottom.top.equalTo(view.safeAreaLayoutGuide).offset(offset)
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func didTap() {
        view.endEditing(true)
    }
}
