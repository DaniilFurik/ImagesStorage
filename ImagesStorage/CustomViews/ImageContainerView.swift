//
//  ImageContainerView.swift
//  ImagesStorage
//
//  Created by Даниил on 11.01.25.
//

import UIKit
import SnapKit

// MARK: - Protocol

protocol ImageContainerViewDelegate: AnyObject {
    func editConstraints(offset: CGFloat, duration: TimeInterval)
    func backPressed()
    func showPicker(with source: UIImagePickerController.SourceType, delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate))
}

// MARK: - Constants

private enum Constants {    
    static let defaultFavoriteImage = UIImage(systemName: GlobalConstants.favoriteImage)
    static let favoriteImage = UIImage(systemName: GlobalConstants.favoriteImage + GlobalConstants.higlightedPostfix)
}

final class ImageContainerView: UIView {
    // MARK: - Properties
    
    private lazy var imageMenuButton: UIButton = {
        let menu = UIMenu(title: GlobalConstants.menuTitle, children: [
            UIAction(title: GlobalConstants.cameraTitle, image: UIImage(systemName: GlobalConstants.cameraImage)) { _ in
                self.delegate?.showPicker(with: .camera, delegate: self)
            },
            UIAction(title: GlobalConstants.libraryTitle, image: UIImage(systemName: GlobalConstants.libraryImage)) { _ in
                self.delegate?.showPicker(with: .photoLibrary, delegate: self)
            }
        ])
        
        let button = UIButton()
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    private lazy var noteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = GlobalConstants.placeholder
        textField.borderStyle = .roundedRect
        textField.delegate = self
        return textField
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: GlobalConstants.fontSize)
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFit
        imageView.image = GlobalConstants.defaultImage
        return imageView
    }()
    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.setImage(UIImage(systemName: GlobalConstants.favoriteImage), for: .normal)
        return button
    }()
    
    private var isNewImage = false
    private var bottomOffset: CGFloat = .zero
    private var customImage = CustomPic()
    weak var delegate: ImageContainerViewDelegate?
    
    // MARK: - Lifecycle
    
    convenience init() {
        self.init(frame: .zero)
        
        initObservers()

        let headerView = UIView()
        addSubview(headerView)
        
        headerView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(GlobalConstants.verticalSpacing)
        }
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: GlobalConstants.backImage), for: .normal)
        backButton.addAction(UIAction(handler: { _ in
            self.delegate?.backPressed()
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
        
        favoriteButton.addAction(UIAction(handler: { [self] _ in
            customImage.info.isFavorite.toggle()
            setFavoriteImage()
        }), for: .touchUpInside)
        headerView.addSubview(favoriteButton)
        
        favoriteButton.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(dateLabel.snp.right).offset(GlobalConstants.horizontalSpacing)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().inset(GlobalConstants.horizontalSpacing)
        }
        
        let middleView = UIView()
        addSubview(middleView)

        middleView.snp.makeConstraints { make in
            make.left.right.equalTo(headerView)
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        middleView.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(GlobalConstants.spacing)
            make.left.right.equalToSuperview()
            make.height.equalTo(UIScreen.main.bounds.height / 2)
        }
        
        imageView.addSubview(imageMenuButton)

        imageMenuButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noteTextField.addAction(UIAction(handler: { [self] _ in
            customImage.info.note = noteTextField.text ?? .empty
        }), for: .allEditingEvents)

        middleView.addSubview(noteTextField)
        
        noteTextField.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(GlobalConstants.horizontalSpacing)
            make.left.equalToSuperview().offset(GlobalConstants.horizontalSpacing)
            make.top.equalTo(imageView.snp.bottom).offset(GlobalConstants.verticalSpacing)
            make.bottom.equalToSuperview()
        }
    }
    
    override func draw(_ rect: CGRect) {
        calculateOffset()
    }
    
    deinit {
        // удаляем наблюдатели, иначе они будут накапливаться?
        removeObservers()
    }
}

extension ImageContainerView: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Methods
    
    func getCustomImageForSaving() -> CustomPic? {
        if  imageView.image == GlobalConstants.defaultImage {
            return nil
        }
        
        // если была выбрана новая картинка в пикере
        if isNewImage,
        let image = imageView.image,
        let dateText = dateLabel.text {
            StorageManager.shared.removeImage(name: customImage.info.imageFileName)
            customImage.info.imageFileName = StorageManager.shared.saveImage(image: image) ?? .empty
            customImage.info.date = Manager.shared.getDate(from: dateText)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
            
            isNewImage = false
        }
        
        customImage.info.note = noteTextField.text ?? .empty
        //customImage.isFavorite - меняется в клике на кнопку
        
        return customImage
    }
    
    func initCustomImage(from customImage: CustomPic) {
        self.customImage = customImage
        
        imageView.image = customImage.image
        dateLabel.text = Manager.shared.getFormattedDate(for: Date(timeIntervalSince1970: TimeInterval(customImage.info.date)))
        noteTextField.text = customImage.info.note
        
        setFavoriteImage()
    }
    
    func getImageViewFrame() -> CGRect {
        guard let superview else { return .zero }
        
        return imageView.convert(imageView.bounds, to: superview.window)
    }
    
    private func setFavoriteImage() {
        if customImage.info.isFavorite {
            favoriteButton.setImage(Constants.favoriteImage, for: .normal)
        } else {
            favoriteButton.setImage(Constants.defaultFavoriteImage, for: .normal)
        }
    }
    
    private func calculateOffset() {
        // определяем где находится TF, чтобы не поднимать экран слишком высоко
        guard let superview,
              let window = superview.window else { return }
        
        let globalFrame = noteTextField.convert(noteTextField.bounds, to: superview.window)
        bottomOffset = window.frame.height - globalFrame.maxY - GlobalConstants.verticalSpacing
    }
    
    private func addImageToScreen(_ image: UIImage) {
        isNewImage = true
        
        imageView.image = image
        dateLabel.text = Manager.shared.getFormattedDate(for: Date())
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            addImageToScreen(image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImageToScreen(image)
        }
        
        picker.dismiss(animated: true)
    }
    
    @objc private func keyboardChangeFrame(_ notification: Notification) {
        guard let info = notification.userInfo,
              let duration = (info[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
              let frame = (info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        var offset: CGFloat = .zero
        
        if notification.name == UIResponder.keyboardWillShowNotification {
            offset = -frame.height + bottomOffset
        }
        
        delegate?.editConstraints(offset: offset, duration: duration)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
}
