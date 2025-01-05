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
    
    static let enterCodeText = "Enter your code"
    static let createCodeText = "Create your code"
    static let confirmCodeText = "Confirm your code"
}

class AuthorizationViewController: UIViewController {
    // MARK: - Lifecycle
    
    private var password = "" {
        didSet {
            passwordLabel.text = password
        }
    }
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
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
        
        let infoLabel = UILabel()
        infoLabel.text = Constants.createCodeText
        infoLabel.font = .systemFont(ofSize: Constants.fontSize, weight: .semibold)
        codeView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        codeView.addSubview(passwordLabel)
        
        passwordLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
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
            if !self.password.isEmpty {
                self.password.removeLast()
            }
        }), for: .touchUpInside)
        buttonsView.addSubview(clearButton)
        
        clearButton.snp.makeConstraints { make in
            make.centerX.equalTo(nineButton)
            make.centerY.equalTo(zeroButton)
            make.width.height.equalTo(zeroButton)
        }
    }
    
    func insertNumber(_ number: Int) {
        password.append(String(number))
    }
}
