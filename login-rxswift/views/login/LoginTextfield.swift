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
        static let spinnerSize = CGSize(width: 30, height: 30)
    }

    let textField = UITextField()
    let placeholderLabel = UILabel()
    private let spinner = LoginSpinnerView(frame: CGRect(
        origin: .zero, size: Constants.spinnerSize))

    private let disposeBag = DisposeBag()

    var isLocked: Bool = false

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
        textField.delegate = self

        placeholderLabel.font = CoreStyle.roboto.regular.withSize(16)
        placeholderLabel.textColor = CoreStyle.color.blue

        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(onButtonTap))
        addGestureRecognizer(tapGestureRecognizer)

        addSubview(textField)
        addSubview(spinner)
        addSubview(placeholderLabel)

        configureObservers()
    }

    private func makeLayout() {
        textField.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(spinner.snp.left).offset(-20)
            make.centerY.equalToSuperview()
        }

        placeholderLabel.snp.makeConstraints { make in
            make.top.left.right.equalTo(textField)
        }

        spinner.snp.makeConstraints { make in
            make.right.equalTo(snp.right).inset(15)
            make.width.height.equalTo(30)
            make.centerY.equalTo(snp.centerY)
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

    func showLoadingSpinner() {
        spinner.reset()
        spinner.startLoading()
    }

    func showCheckMark() {
        spinner.done()
    }

    func hideSpinner() {
        spinner.fadeOut()
    }

}

extension LoginTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
        replacementString string: String) -> Bool {
            return !isLocked
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}
