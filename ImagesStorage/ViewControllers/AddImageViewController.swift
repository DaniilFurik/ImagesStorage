//
//  AddImageViewController.swift
//  ImagesStorage
//
//  Created by Даниил on 7.01.25.
//

import UIKit

// MARK: - Constants

private enum Constants {
    static let backImage = "chevron.left"
    static let favoriteImage = "heart"
    static let cameraImage = "camera"
    static let libraryImage = "photo"
    static let plusImage = "plus.circle"
    
    static let settingsTitle = "Settings"
    static let menuTitle = "Select photo source"
    static let cameraTitle = "Camera"
    static let libraryTitle = "Photo Library"
    
    static let placeholder = "Enter your note"
    
    static let defaultImage = UIImage(systemName: Constants.plusImage)
}

class AddImageViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var noteTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = Constants.placeholder
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
        imageView.image = Constants.defaultImage
        return imageView
    }()
    
    private lazy var imageMenuButton: UIButton = {
        let menu = UIMenu(title: Constants.menuTitle, children: [
            UIAction(title: Constants.cameraTitle, image: UIImage(systemName: Constants.cameraImage)) { _ in
                self.showPhotoPicker(with: .camera, delegate: self)
            },
            UIAction(title: Constants.libraryTitle, image: UIImage(systemName: Constants.libraryImage)) { _ in
                self.showPhotoPicker(with: .photoLibrary, delegate: self)
            }
        ])
        
        let button = UIButton()
        button.menu = menu
        button.showsMenuAsPrimaryAction = true
        
        return button
    }()
    
    private var bottomOffset: CGFloat = .zero
    private var isFavorite = false
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initObservers()
        configureUI()
        
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

extension AddImageViewController: UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
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
        backButton.setImage(UIImage(systemName: Constants.backImage), for: .normal)
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
        
        let favotiteButton = UIButton(type: .system)
        favotiteButton.tintColor = .systemRed
        favotiteButton.setImage(UIImage(systemName: Constants.favoriteImage), for: .normal)
        favotiteButton.addAction(UIAction(handler: { _ in
            if self.isFavorite {
                favotiteButton.setImage(UIImage(systemName: Constants.favoriteImage), for: .normal)
            } else {
                favotiteButton.setImage(UIImage(systemName: Constants.favoriteImage + GlobalConstants.higlightedPostfix), for: .normal)
            }
            
            self.isFavorite.toggle()
            
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
            make.bottom.lessThanOrEqualToSuperview()
        }
    
        middleView.addSubview(imageView)
 
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(GlobalConstants.spacing)
            make.left.right.equalToSuperview()
            make.height.equalTo(view).dividedBy(2)
        }
        
        imageView.addSubview(imageMenuButton)
        
        imageMenuButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        noteTextField.setContentHuggingPriority(.defaultHigh, for: .vertical) // сохраняет минимальный размер по вертикали
        middleView.addSubview(noteTextField)
        
        noteTextField.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(GlobalConstants.horizontalSpacing)
            make.left.equalToSuperview().offset(GlobalConstants.horizontalSpacing)
            make.top.equalTo(imageView.snp.bottom).offset(GlobalConstants.verticalSpacing)
            make.bottom.equalToSuperview().inset(GlobalConstants.spacing)
        }
    }
    
    private func backPressed() {
        // если не добавлили картинку, то идем назад
        if imageView.image == Constants.defaultImage {
            navigationController?.popViewController(animated: true)
        } else {
            // если добавлили картинку, то сохраняем и идем на список всех картинок
            saveNewImage()
            
            // open new controller
            navigationController?.popViewController(animated: true)
        }
        
        // удаляем наблюдатели, иначе они будут накапливаться
        removeObservers()
    }
    
    private func addImageToScreen(_ image: UIImage) {
        imageView.image = image
        dateLabel.text = Manager.shared.getForrmatedDate(for: Date())
    }
    
    private func saveNewImage() {
        let date =  Manager.shared.getDate(from: dateLabel.text!)?.timeIntervalSince1970 ?? Date().timeIntervalSince1970
        let imageFileName = StorageManager.shared.saveImage(image: imageView.image!) ?? .empty
        
        let customImage = CustomImage(
            note: noteTextField.text ?? .empty,
            isFavorite: isFavorite,
            imageFileName: imageFileName,
            date: date
            )
        
        StorageManager.shared.saveCustomImage(customImage: customImage)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            addImageToScreen(image)
        } else if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImageToScreen(image)
        }
        
        picker.dismiss(animated: true)
    }
    
    @objc private func didTap() {
        view.endEditing(true)
    }
}
