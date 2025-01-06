//
//  InitialViewController.swift
//  ImagesStorage
//
//  Created by Даниил on 1.01.25.
//

import UIKit
import SnapKit

// MARK: - Constants

private enum Constants {
    static let oneButtonImage = "1.circle"
    static let twoButtonImage = "2.circle"
    static let threeButtonImage = "3.circle"
    static let fourButtonImage = "4.circle"
    static let fiveButtonImage = "5.circle"
    static let sixButtonImage = "6.circle"
    static let sevenButtonImage = "7.circle"
    static let eightButtonImage = "8.circle"
    static let nineButtonImage = "9.circle"
    static let zeroButtonImage = "0.circle"
    static let clearButtonImage = "c.circle"
    
    static let spacing: CGFloat = 16
    static let bigSpacing: CGFloat = 48
    static let fontSize: CGFloat = 24
    static let imageSize: CGFloat = 50
    
    static let enterCodeText = "Enter your code"
    static let createCodeText = "Create your code"
    static let confirmCodeText = "Confirm your code"
    
    static let delay: TimeInterval = 0.3
    static let shortDelay: TimeInterval = 0.1
}

class AuthorizationViewController: UIViewController {
    // MARK: - Properties
    
    private let firstImage: CodeImage = {
        return CodeImage()
    }()
    
    private let secondImage: CodeImage = {
        return CodeImage()
    }()
    
    private let thirdImage: CodeImage = {
        return CodeImage()
    }()
    
    private let fourthImage: CodeImage = {
        return CodeImage()
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constants.fontSize, weight: .semibold)
        return label
    }()
    
    private lazy var imagesArray = [firstImage, secondImage, thirdImage, fourthImage]

    private var enteredPassword = ""
    private var confirmedPassword: String?
    private var savedPassword: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        initPassword()
    }
}

private extension AuthorizationViewController {
    // MARK: - Methods
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        let codeView = UIView()
        view.addSubview(codeView)
        
        codeView.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        codeView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.bigSpacing)
            make.centerX.equalToSuperview()
        }
        
        codeView.addSubview(secondImage)
        
        secondImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(codeView.snp.centerX).offset(-Constants.spacing / 2)
            make.width.height.equalTo(Constants.imageSize)
        }
        
        codeView.addSubview(firstImage)
        
        firstImage.snp.makeConstraints { make in
            make.top.equalTo(secondImage)
            make.right.equalTo(secondImage.snp.left).offset(-Constants.spacing)
            make.width.height.equalTo(secondImage)
        }
        
        codeView.addSubview(thirdImage)
        
        thirdImage.snp.makeConstraints { make in
            make.top.equalTo(secondImage)
            make.left.equalTo(codeView.snp.centerX).offset(Constants.spacing / 2)
            make.width.height.equalTo(secondImage)
        }
        
        codeView.addSubview(fourthImage)
        
        fourthImage.snp.makeConstraints { make in
            make.top.equalTo(secondImage)
            make.left.equalTo(thirdImage.snp.right).offset(Constants.spacing)
            make.width.height.equalTo(secondImage)
        }
        
        let buttonsView = UIView()
        view.addSubview(buttonsView)
        
        buttonsView.snp.makeConstraints { make in
            make.top.equalTo(codeView.snp.bottom)
            make.bottom.left.right.equalTo(view.safeAreaLayoutGuide)
        }
        
        let oneButton = CodeButton(imageName: Constants.oneButtonImage)
        oneButton.addAction(UIAction(handler: { _ in self.insertNumber(1) }), for: .touchUpInside)
        buttonsView.addSubview(oneButton)
        
        oneButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(Constants.bigSpacing)
            make.width.equalTo(oneButton.snp.height)
        }
        
        let twoButton = CodeButton(imageName: Constants.twoButtonImage)
        twoButton.addAction(UIAction(handler: { _ in self.insertNumber(2) }), for: .touchUpInside)
        buttonsView.addSubview(twoButton)
        
        twoButton.snp.makeConstraints { make in
            make.left.equalTo(oneButton.snp.right).offset(Constants.spacing)
            make.top.bottom.width.height.equalTo(oneButton)
        }
        
        let threeButton = CodeButton(imageName: Constants.threeButtonImage)
        threeButton.addAction(UIAction(handler: { _ in self.insertNumber(3) }), for: .touchUpInside)
        buttonsView.addSubview(threeButton)
        
        threeButton.snp.makeConstraints { make in
            make.left.equalTo(twoButton.snp.right).offset(Constants.spacing)
            make.right.equalToSuperview().inset(Constants.bigSpacing)
            make.top.bottom.width.height.equalTo(twoButton)
        }
        
        let fourButton = CodeButton(imageName: Constants.fourButtonImage)
        fourButton.addAction(UIAction(handler: { _ in self.insertNumber(4) }), for: .touchUpInside)
        buttonsView.addSubview(fourButton)
        
        fourButton.snp.makeConstraints { make in
            make.top.equalTo(oneButton.snp.bottom).offset(Constants.spacing)
            make.left.width.height.equalTo(oneButton)
        }
        
        let fiveButton = CodeButton(imageName: Constants.fiveButtonImage)
        fiveButton.addAction(UIAction(handler: { _ in self.insertNumber(5) }), for: .touchUpInside)
        buttonsView.addSubview(fiveButton)
        
        fiveButton.snp.makeConstraints { make in
            make.left.equalTo(fourButton.snp.right).offset(Constants.spacing)
            make.top.bottom.width.height.equalTo(fourButton)
        }
        
        let sixButton = CodeButton(imageName: Constants.sixButtonImage)
        sixButton.addAction(UIAction(handler: { _ in self.insertNumber(6) }), for: .touchUpInside)
        buttonsView.addSubview(sixButton)
        
        sixButton.snp.makeConstraints { make in
            make.left.equalTo(fiveButton.snp.right).offset(Constants.spacing)
            make.top.bottom.width.height.equalTo(fiveButton)
        }
        
        let sevenButton = CodeButton(imageName: Constants.sevenButtonImage)
        sevenButton.addAction(UIAction(handler: { _ in self.insertNumber(7) }), for: .touchUpInside)
        buttonsView.addSubview(sevenButton)
        
        sevenButton.snp.makeConstraints { make in
            make.top.equalTo(fourButton.snp.bottom).offset(Constants.spacing)
            make.left.width.height.equalTo(oneButton)
        }
        
        let eightButton = CodeButton(imageName: Constants.eightButtonImage)
        eightButton.addAction(UIAction(handler: { _ in self.insertNumber(8) }), for: .touchUpInside)
        buttonsView.addSubview(eightButton)
        
        eightButton.snp.makeConstraints { make in
            make.left.equalTo(sevenButton.snp.right).offset(Constants.spacing)
            make.top.bottom.width.height.equalTo(sevenButton)
        }
        
        let nineButton = CodeButton(imageName: Constants.nineButtonImage)
        nineButton.addAction(UIAction(handler: { _ in self.insertNumber(9) }), for: .touchUpInside)
        buttonsView.addSubview(nineButton)
        
        nineButton.snp.makeConstraints { make in
            make.left.equalTo(eightButton.snp.right).offset(Constants.spacing)
            make.top.bottom.width.height.equalTo(eightButton)
        }
        
        let zeroButton = CodeButton(imageName: Constants.zeroButtonImage)
        zeroButton.addAction(UIAction(handler: { _ in self.insertNumber(0) }), for: .touchUpInside)
        buttonsView.addSubview(zeroButton)
        
        zeroButton.snp.makeConstraints { make in
            make.left.right.height.equalTo(eightButton)
            make.top.equalTo(eightButton.snp.bottom).offset(Constants.spacing)
            make.bottom.equalToSuperview().inset(Constants.bigSpacing)
        }
        
        let clearButton = CodeButton(imageName: Constants.clearButtonImage)
        clearButton.addAction(UIAction(handler: { _ in
            self.removeNumber()
        }), for: .touchUpInside)
        buttonsView.addSubview(clearButton)
        
        clearButton.snp.makeConstraints { make in
            make.centerX.equalTo(nineButton)
            make.centerY.equalTo(zeroButton)
            make.width.height.equalTo(zeroButton)
        }
    }
    
    func insertNumber(_ number: Int) {
        if enteredPassword.count < imagesArray.count {
            enteredPassword.append(String(number))
            imagesArray[enteredPassword.count - 1].isHighlighted = true
            
            if enteredPassword.count == imagesArray.count {
                if savedPassword != nil {
                    checkPassword()
                } else if confirmedPassword != nil {
                    checkConfirmPassword()
                } else {
                    initConfirmPassword()
                }
            }
        }
    }
    
    func removeNumber() {
        if !enteredPassword.isEmpty {
            imagesArray[enteredPassword.count - 1].isHighlighted = false
            enteredPassword.removeLast()
        }
    }
    
    func checkPassword() {
        if enteredPassword == savedPassword {
            imagesArray.forEach({ codeImage in
                codeImage.tintColor = .systemGreen
            })
            
            Timer.scheduledTimer(withTimeInterval: Constants.shortDelay, repeats: false) { [self] _ in
                view.window?.rootViewController = UINavigationController(rootViewController: MainViewController())
            }
        } else {
            imagesArray.forEach({ codeImage in
                codeImage.tintColor = .systemRed
            })
            
            resetImages()
        }
        
        enteredPassword = .empty
    }
    
    func checkConfirmPassword() {
        if enteredPassword == confirmedPassword {
            imagesArray.forEach({ codeImage in
                codeImage.tintColor = .systemGreen
            })
            
            UserDefaults.standard.set(confirmedPassword, forKey: .keyPassword)
            initPassword()
        } else {
            imagesArray.forEach({ codeImage in
                codeImage.tintColor = .systemRed
            })
        }
        
        resetImages()
        
        enteredPassword = .empty
    }
    
    func initPassword() {
        savedPassword = UserDefaults.standard.string(forKey: .keyPassword)
        
        if savedPassword != nil {
            infoLabel.text = Constants.enterCodeText
        } else {
            infoLabel.text = Constants.createCodeText
        }
    }
    
    func initConfirmPassword() {
        Timer.scheduledTimer(withTimeInterval: Constants.shortDelay, repeats: false) { [self] _ in
            infoLabel.text = Constants.confirmCodeText
            
            imagesArray.forEach({ codeImage in
                codeImage.isHighlighted = false
            })
        }
        
        confirmedPassword = enteredPassword
        enteredPassword = .empty
    }
    
    func resetImages() {
        Timer.scheduledTimer(withTimeInterval: Constants.delay, repeats: false) { [self] _ in
            imagesArray.forEach({ codeImage in
                codeImage.isHighlighted = false
            })
            imagesArray.forEach({ codeImage in
                codeImage.tintColor = .accent
            })
        }
    }
}
