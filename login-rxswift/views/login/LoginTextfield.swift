//
//  UIColor.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginTextField: UIView {
    private struct Constants {
        static let alphaAnimationDuration = 0.2
    }
    let textField = UITextField()
    let placeholderLabel = UILabel()

    private let disposeBag = DisposeBag()

    init(placeholderText: String) {
        super.init(frame: CGRect.zero)
        placeholderLabel.text = placeholderText

        loadContent()
        makeLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadContent() {
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.tintColor = CoreStyle.color.blue
        textField.textColor = CoreStyle.color.blue
        textField.font = CoreStyle.roboto.regular.withSize(16)

        placeholderLabel.font = CoreStyle.roboto.regular.withSize(16)
        placeholderLabel.textColor = CoreStyle.color.blue

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(onButtonTap))
        addGestureRecognizer(tapGestureRecognizer)

        addSubview(textField)
        addSubview(placeholderLabel)

        configureObservers()
    }

    private func makeLayout() {
        textField.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.centerY.equalToSuperview()
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(textField)
        }
    }

    private func configureObservers() {
        textField.rx.controlEvent(.editingDidBegin)
            .subscribe(onNext: { [weak self] _ in
                UIView.animate(withDuration: Constants.alphaAnimationDuration) {
                    self?.placeholderLabel.alpha = 0
                }
            })
            .addDisposableTo(disposeBag)

        textField.rx.controlEvent(.editingDidEnd)
            .subscribe(onNext: { [weak self] _ in
                guard let this = self else {
                    return
                }

                if this.textField.text?.isEmpty == false {
                    this.placeholderLabel.alpha = 0
                    return
                }

                UIView.animate(withDuration: Constants.alphaAnimationDuration) {
                    this.placeholderLabel.alpha = 1
                }
            })
            .addDisposableTo(disposeBag)
    }

    func onButtonTap() {
        textField.becomeFirstResponder()
    }

    func cleanContent() {
        textField.text = ""
    }
}
