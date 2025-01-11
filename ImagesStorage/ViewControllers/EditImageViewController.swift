//
//  EditImageViewController.swift
//  ImagesStorage
//
//  Created by Даниил on 9.01.25.
//

import UIKit

// MARK: - Constants

private enum Constants {
    static let defaultFavoriteImage = UIImage(systemName: GlobalConstants.favoriteImage)
    static let favoriteImage = UIImage(systemName: GlobalConstants.favoriteImage + GlobalConstants.higlightedPostfix)
    
    static let arrowLeftImage = "arrow.left.circle"
    static let arrowRightImage = "arrow.right.circle"
    
    static let buttonSize: CGFloat = 48
    
    static let animationDuration: TimeInterval = 0.3
    
    static let picOutOfText = "pic out of"
    static let picsText = "pics"
}

class EditImageViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var noteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = GlobalConstants.placeholder
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
    
    private let containerView: UIView = {
        return UIView()
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let favotiteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.setImage(UIImage(systemName: GlobalConstants.favoriteImage), for: .normal)
        return button
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = .zero
        label.textAlignment = .center
        return label
    }()
    
    private var bottomOffset: CGFloat = .zero
    private var customImages = [CustomImage]()
    private var currentIndex: Int = .zero
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initObservers()
        configureUI()
        initData()
        
        containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // определяем где находится TF, чтобы не поднимать экран слишком высоко
        if let frame = noteTextField.frame(in: view) {
            bottomOffset = view.frame.height - frame.maxY - GlobalConstants.verticalSpacing
        }
    }
}

extension EditImageViewController: UITextFieldDelegate, UINavigationControllerDelegate {
    // MARK: - Methods

    private func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.left.right.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        let headerView = UIView()
        containerView.addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: GlobalConstants.backImage), for: .normal)
        backButton.addAction(UIAction(handler: { _ in
            self.backPressed()
        }), for: .touchUpInside)
        headerView.addSubview(backButton)
        
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(GlobalConstants.horizontalSpacing)
            make.top.bottom.equalToSuperview()
        }
        
        headerView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.greaterThanOrEqualTo(backButton.snp.right).offset(GlobalConstants.horizontalSpacing)
            make.centerX.equalToSuperview()
        }
        
        favotiteButton.addAction(UIAction(handler: { [self] _ in
            customImages[currentIndex].isFavorite.toggle()
            setFavoriteImage()
        }), for: .touchUpInside)
        headerView.addSubview(favotiteButton)
        
        favotiteButton.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(dateLabel.snp.right).offset(GlobalConstants.horizontalSpacing)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(GlobalConstants.horizontalSpacing)
        }
        
        let middleView = UIView()
        containerView.addSubview(middleView)
        
        middleView.snp.makeConstraints { make in
            make.left.right.equalTo(headerView)
            make.top.equalTo(headerView.snp.bottom)
        }
        
        middleView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(GlobalConstants.spacing)
            make.left.right.equalToSuperview()
            make.height.equalTo(view).dividedBy(2)
        }
        
        noteTextField.addAction(UIAction(handler: { [self] _ in
            customImages[currentIndex].note = noteTextField.text!
        }), for: .allEditingEvents)
        noteTextField.setContentHuggingPriority(.defaultHigh, for: .vertical) // сохраняет минимальный размер по вертикали
        middleView.addSubview(noteTextField)
        
        noteTextField.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(GlobalConstants.horizontalSpacing)
            make.left.equalToSuperview().offset(GlobalConstants.horizontalSpacing)
            make.top.equalTo(imageView.snp.bottom).offset(GlobalConstants.verticalSpacing)
            make.bottom.equalToSuperview().inset(GlobalConstants.spacing)
        }
        
        let bottomView = UIView()
        containerView.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.left.right.equalTo(headerView)
            make.top.equalTo(middleView.snp.bottom)
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
    
    private func backPressed() {
        navigationController?.popViewController(animated: true)
        
        StorageManager.shared.saveCustomImages(customImages: customImages)
        
        // удаляем наблюдатели, иначе они будут накапливаться
        removeObservers()
    }
    
    private func initData() {
        customImages = StorageManager.shared.getCustomImages()
        
        initCurrentCustomImage(from: StorageManager.shared.getImage(fileName: customImages[currentIndex].imageFileName)!)
    }
    
    private func initCurrentCustomImage(from image: UIImage) {
        imageView.image = image
        noteTextField.text = customImages[currentIndex].note
        dateLabel.text = Manager.shared.getForrmatedDate(for: Date(timeIntervalSince1970: TimeInterval(customImages[currentIndex].date)))
        infoLabel.text = "\(currentIndex + 1) \(Constants.picOutOfText) \(customImages.count) \(Constants.picsText)"

        setFavoriteImage()
    }
    
    private func setFavoriteImage() {
        if customImages[currentIndex].isFavorite {
            favotiteButton.setImage(Constants.favoriteImage, for: .normal)
        } else {
            favotiteButton.setImage(Constants.defaultFavoriteImage, for: .normal)
        }
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
    
    private func leftPressed() {
        calculateCurrentIndex(isNext: false)
        
        animateTempImage(fromX: .zero, toX: -imageView.frame.width, image: imageView.image!)
        
        let image = StorageManager.shared.getImage(fileName: customImages[currentIndex].imageFileName)
        self.initCurrentCustomImage(from: image!)
    }
    
    private func rightPressed() {
        calculateCurrentIndex(isNext: true)
        
        let image = StorageManager.shared.getImage(fileName: customImages[currentIndex].imageFileName)
        animateTempImage(fromX: imageView.frame.maxX, toX: .zero, image: image!)
    }
    
    private func animateTempImage(fromX: CGFloat, toX: CGFloat, image: UIImage) {
        let tempImageView = UIImageView(image: image)
        tempImageView.backgroundColor = .systemBackground
        tempImageView.contentMode = .scaleAspectFit
        imageView.addSubview(tempImageView)
        
        tempImageView.frame = CGRect(
            x: fromX,
            y: .zero,
            width: imageView.frame.width,
            height: imageView.frame.height
        )
        
        UIView.animate(withDuration: Constants.animationDuration) {
            tempImageView.frame.origin.x = toX
        } completion: { _ in
            tempImageView.removeFromSuperview()
            
            // если анимация была спарва
            if toX == .zero {
                self.initCurrentCustomImage(from: image)
            }
        }
    }
    
    private func initObservers() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardChangeFrame(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardChangeFrame(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    private func removeObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardChangeFrame(_ notification: Notification) {
        guard let info = notification.userInfo,
              let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var offset: CGFloat = .zero
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            offset = -frame.height + bottomOffset
        }
        
        containerView.snp.updateConstraints { make in
            make.bottom.top.equalTo(view.safeAreaLayoutGuide).offset(offset)
        }
        
        UIView.animate(withDuration: duration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func didTap() {
        view.endEditing(true)
    }
}
