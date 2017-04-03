//
//  LoginViewController.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

typealias LoginFloatState = (expanded: CGFloat, collapsed: CGFloat)

class LoginViewController: UIViewController {
    private struct Constants {
        static let emailPlaceholderText = "E-mail"
        static let passwordPlaceholderText = "Senha"
        static let welcomeText = "Bem-vindo(a)"
        static let headerHeight: LoginFloatState = (250, 100)
        static let transitionDuration = 0.8
        static let transtiionDamping = CGFloat(0.7)
        static let errorTitle = "Erro"
        static let errorMessage = "Problema ao estabelecer conexao com o servidor"
        static let errorOkButtonTitle = "OK"
    }

    let viewModel = LoginViewModel()

    let headerContainer = LoginHeaderContainer()

    let formContainer = UIView()
    let welcomeContainer = UIView()
    let welcomeTitle = UILabel()

    let inputContainer = UIView()
    let inputContainerBottomLine = UIView()
    let emailTextfield = LoginTextField(placeholderText: Constants.emailPlaceholderText)
    let passwordTextfield = LoginTextField(placeholderText: Constants.passwordPlaceholderText)
    let enterButton = LoginButton()


    let disposeBag = DisposeBag()

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        loadContent()
        makeLayout()
    }

    private func loadContent() {
        passwordTextfield.textField.isSecureTextEntry = true

        view.backgroundColor = CoreStyle.color.white

        inputContainerBottomLine.backgroundColor = CoreStyle.color.blue

        let tap = UITapGestureRecognizer(target: self, action: #selector(attemptToDismissKeyBoard))
        view.addGestureRecognizer(tap)

        welcomeContainer.alpha = 0

        welcomeTitle.text = Constants.welcomeText
        welcomeTitle.textAlignment = .center
        welcomeTitle.font = CoreStyle.roboto.bold.withSize(34)
        welcomeTitle.textColor = CoreStyle.color.blue

        view.addSubview(formContainer)
        view.addSubview(welcomeContainer)

        formContainer.addSubview(headerContainer)
        formContainer.addSubview(inputContainer)
        inputContainer.addSubview(emailTextfield)
        inputContainer.addSubview(passwordTextfield)
        inputContainer.addSubview(inputContainerBottomLine)
        formContainer.addSubview(enterButton)

        welcomeContainer.addSubview(welcomeTitle)

        configureViewModelObservers()
        configureFocusObservers()
    }

    private func makeLayout() {
        formContainer.snp.makeConstraints { make in
            make.left.equalToSuperview()
        }
        makeBaseFullScreenLayout(view: formContainer)

        welcomeContainer.snp.makeConstraints { make in
            make.left.equalTo(view.snp.right)
        }
        makeBaseFullScreenLayout(view: welcomeContainer)

        welcomeTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.right.equalToSuperview()
        }

        headerContainer.snp.makeConstraints { make in
            make.height.equalTo(Constants.headerHeight.expanded)
        }
        makeBaseHeaderLayout()

        inputContainer.snp.makeConstraints { make in
            make.top.equalTo(headerContainer.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(40)
        }

        inputContainerBottomLine.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }

        emailTextfield.snp.makeConstraints { make in
            make.left.equalTo(20)
        }
        makeBaseLayout(inputView: emailTextfield)

        passwordTextfield.snp.makeConstraints { make in
            make.left.equalTo(view.snp.right).offset(20)
        }
        makeBaseLayout(inputView: passwordTextfield)

        enterButton.snp.makeConstraints { make in
            make.top.equalTo(inputContainer.snp.bottom).offset(50)
            make.left.equalTo(20)
            make.width.equalToSuperview().inset(20)
        }
    }

    private func makeBaseFullScreenLayout(view: UIView) {
        view.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }
    }
    private func makeBaseHeaderLayout() {
        headerContainer.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(topLayoutGuide.snp.bottom)
        }
    }

    private func makeBaseLayout(inputView: UIView) {
        inputView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.width.equalToSuperview().inset(20)
            make.height.equalToSuperview()
        }
    }

    private func configureViewModelObservers() {
        emailTextfield.textField.rx.text.orEmpty
            .bindTo(viewModel.emailText)
            .addDisposableTo(disposeBag)

        passwordTextfield.textField.rx.text.orEmpty
            .bindTo(viewModel.passwordText)
            .addDisposableTo(disposeBag)

        viewModel.isEnterButtonValid
            .bindTo(enterButton.rx.isEnabled)
            .addDisposableTo(disposeBag)

        viewModel.enterButtonTextObservable
            .subscribe(onNext: { [weak self] text in
                self?.enterButton.text = text
            }).addDisposableTo(disposeBag)

        enterButton.rx.tap
            .bindTo(viewModel.didTapEnterButton)
            .addDisposableTo(disposeBag)

        viewModel.updateToNextState
            .skip(1)
            .subscribe(onNext: { [weak self] loginStateUpdate in
                self?.update(with: loginStateUpdate)
            }).addDisposableTo(disposeBag)

        headerContainer.passwordTitle.backButton.rx.tap
            .bindTo(viewModel.didTapBackButton)
            .addDisposableTo(disposeBag)

        viewModel.errorDidOccurObservable
            .subscribe(onNext: { [weak self] error in
                self?.presentGenericErrorAlert()
            }).addDisposableTo(disposeBag)
    }

    private func configureFocusObservers() {
        let didFocusEmail = emailTextfield
            .textField.rx.controlEvent(.editingDidBegin).do(onNext: { _ in
                self.headerContainer.showEmailTitle()
            })
        let didFocusPassword = passwordTextfield
            .textField.rx.controlEvent(.editingDidBegin).asObservable()
        Observable.of(
            didFocusEmail,
            didFocusPassword)
            .merge()
            .subscribe(onNext: { [weak self] in
                self?.collapseHeader()
            }).addDisposableTo(disposeBag)

        viewModel.resignKeyboardObservable
            .subscribe(onNext: { [weak self] in
                self?.expandHeader()
                self?.headerContainer.showWelcomeTiltle()
                KeyboardHelper.dismissKeyboard()
            }).addDisposableTo(disposeBag)
    }

    private func update(with loginStateUpdate: LoginStateUpdate) {
        switch (loginStateUpdate.fromState, loginStateUpdate.toState) {
        case (_, .emailState):
            animateToEmail()
            headerContainer.showEmailTitle()
            emailTextfield.textField.becomeFirstResponder()
        case (.emailState, .passwordState):
            animateToPassword()
            headerContainer.showPasswordTitle()
            passwordTextfield.cleanContent()
            passwordTextfield.textField.becomeFirstResponder()
        case (.signingInState, .passwordState):
            passwordTextfield.hideSpinner()
            passwordTextfield.isLocked = false
        case (_, .signingInState):
            passwordTextfield.showLoadingSpinner()
            passwordTextfield.isLocked = true
        case (_, .signedInState):
            passwordTextfield.showCheckMark()
        case (_, .welcomeState):
            pushWelcomeScreen()
            KeyboardHelper.dismissKeyboard()
        case (_, _): break
        }
    }

    func attemptToDismissKeyBoard() {
        viewModel.didAttemptToResignKeyboard.onNext()
    }

    private func animateToEmail() {
        emailTextfield.snp.remakeConstraints { make in
            make.left.equalTo(20)
        }
        makeBaseLayout(inputView: emailTextfield)

        passwordTextfield.snp.remakeConstraints { make in
            make.left.equalTo(view.snp.right).offset(20)
        }
        makeBaseLayout(inputView: passwordTextfield)

        springTransition { [weak self] in
            self?.inputContainer.layoutIfNeeded()
        }
    }

    private func animateToPassword() {
        emailTextfield.snp.remakeConstraints { make in
            make.right.equalTo(inputContainer.snp.left).offset(-20)
        }
        makeBaseLayout(inputView: emailTextfield)

        passwordTextfield.snp.remakeConstraints { make in
            make.left.equalTo(20)
        }
        makeBaseLayout(inputView: passwordTextfield)

        springTransition { [weak self] in
            self?.inputContainer.layoutIfNeeded()
        }
    }

    private func collapseHeader() {
        headerContainer.snp.remakeConstraints { make in
            make.height.equalTo(Constants.headerHeight.collapsed)
        }
        makeBaseHeaderLayout()

        springTransition { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func expandHeader() {
        headerContainer.snp.remakeConstraints { make in
            make.height.equalTo(Constants.headerHeight.expanded)
        }
        makeBaseHeaderLayout()

        springTransition { [weak self] in
            self?.view.layoutIfNeeded()
        }
    }

    private func customTimingTransition(block: @escaping () -> Void) {
        let timingFunction = CAMediaTimingFunction(controlPoints: 0.56, 0, 0.43, 1)

        CATransaction.begin()
        CATransaction.setAnimationTimingFunction(timingFunction)
        UIView.animate(withDuration: 0.4, animations: {
            block()
        })

        CATransaction.commit()
    }

    private func springTransition(block: @escaping () -> Void) {
        UIView.animate(withDuration: Constants.transitionDuration, delay: 0,
            usingSpringWithDamping: Constants.transtiionDamping,
            initialSpringVelocity: 0, options: [.curveEaseOut], animations: {
                block()
            })
    }

    private func pushWelcomeScreen() {
        formContainer.snp.remakeConstraints { make in
            make.right.equalTo(view.snp.left)
        }
        makeBaseFullScreenLayout(view: formContainer)

        welcomeContainer.snp.remakeConstraints { make in
            make.left.equalToSuperview()
        }
        makeBaseFullScreenLayout(view: welcomeContainer)

        customTimingTransition { [weak self] in
            self?.formContainer.alpha = 0
            self?.view.layoutIfNeeded()
        }

        UIView.animate(withDuration: 0.4, delay: 0.4, options: [],
            animations: { [weak self] in
                self?.welcomeContainer.alpha = 1
        }, completion: nil)
    }

    private func presentGenericErrorAlert() {
        let alertController = UIAlertController(
            title: Constants.errorTitle,
            message: Constants.errorMessage, preferredStyle: .alert)

        alertController.addAction(UIAlertAction(
            title: Constants.errorOkButtonTitle,
            style: .default, handler: nil))

        present(alertController, animated: true, completion: nil)
    }
}
