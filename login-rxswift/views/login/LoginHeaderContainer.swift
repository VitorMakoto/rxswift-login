//
//  UIColor.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import UIKit
import SnapKit

class LoginHeaderContainer: UIView {
    private struct Constants {
        static let alphaAnimationDuration = 0.2
        static let welcomeText = "Olá"
        static let emailText = "Digite o e-mail:"
//        static let passwordText = "Agora digite a senha:"
    }
    private let welcomeTitle = UILabel()
    private let emailTitle = UILabel()
    let passwordTitle = LoginPasswordTitle()

    let allTitles: [UIView]

    init() {
        self.allTitles = [welcomeTitle, emailTitle, passwordTitle]

        super.init(frame: CGRect.zero)
        loadContent()
        makeLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadContent() {
        welcomeTitle.text = Constants.welcomeText
        welcomeTitle.textAlignment = .center
        welcomeTitle.font = CoreStyle.roboto.bold.withSize(100)
        welcomeTitle.textColor = CoreStyle.color.blue

        emailTitle.text = Constants.emailText
        emailTitle.textAlignment = .left
        emailTitle.font = CoreStyle.roboto.bold.withSize(20)
        emailTitle.textColor = CoreStyle.color.blue
        emailTitle.alpha = 0

        passwordTitle.alpha = 0

        addSubview(welcomeTitle)
        addSubview(emailTitle)
        addSubview(passwordTitle)
    }

    private func makeLayout() {
        welcomeTitle.snp.makeConstraints { make in
            make.centerY.equalTo(125)
            make.left.right.equalToSuperview()
        }

        emailTitle.snp.makeConstraints { make in
            make.top.equalTo(70)
            make.left.equalTo(CoreStyle.gutter.left*2)
            make.right.equalTo(CoreStyle.gutter.right)
        }

        passwordTitle.snp.makeConstraints { make in
            make.top.equalTo(70)
            make.left.equalTo(CoreStyle.gutter.left)
            make.right.equalTo(CoreStyle.gutter.right)
        }
    }

    func showWelcomeTiltle() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let this = self else {
                return
            }

            this.allTitles.filter { $0 != this.welcomeTitle }
                .forEach { $0.alpha = 0}
        }

        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: { [weak self] in
            self?.welcomeTitle.alpha = 1
        }, completion: nil)
    }

    func showEmailTitle() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let this = self else {
                return
            }

            this.allTitles.filter { $0 != this.emailTitle }
                .forEach { $0.alpha = 0}
        }

        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: { [weak self] in
            self?.emailTitle.alpha = 1
        }, completion: nil)
    }

    func showPasswordTitle() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let this = self else {
                return
            }

            this.allTitles.filter { $0 != this.passwordTitle }
                .forEach { $0.alpha = 0}
        }

        UIView.animate(withDuration: 0.2, delay: 0.2, options: [], animations: { [weak self] in
            self?.passwordTitle.alpha = 1
            }, completion: nil)
    }
}
