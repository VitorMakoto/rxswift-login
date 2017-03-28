//
//  LoginViewController.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import Foundation
import RxSwift

enum LoginState {
    case emailState
    case passwordState
    case signingInState
    case welcomeState
}

extension LoginState {
    var enterButtonText: String {
        switch self {
        case .emailState: return "Próximo"
        case .passwordState, .signingInState, .welcomeState: return "Entrar"
        }
    }
}

class LoginViewModel {
    private let currentState = BehaviorSubject<LoginState>(value: .emailState)
    private let errorDidOccur = PublishSubject<Void>()

    let emailText = BehaviorSubject<String>(value: "")
    let passwordText = BehaviorSubject<String>(value: "")
    let didTapEnterButton = PublishSubject<Void>()
    let didTapBackButton = PublishSubject<Void>()
    let didAttemptToResignKeyboard = PublishSubject<Void>()

    let isEnterButtonValid: Observable<Bool>
    let enterButtonTextObservable: Observable<String>

    var currenStateObservable: Observable<LoginState> {
        return currentState.asObservable()
    }

    var errorDidOccurObservable: Observable<Void> {
        return errorDidOccur.asObservable()
    }

    var resignKeyboardObservable: Observable<Void> {
        return didAttemptToResignKeyboard
            .withLatestFrom(currentState) { $1 }
            .filter { $0 == .emailState }
            .map { _ in return }
    }

    let disposeBag = DisposeBag()

    init() {
        isEnterButtonValid = Observable
            .combineLatest(emailText, passwordText, currentState) { $0 }
            .map { emailText, passwordText, state in
                switch state {
                case .emailState:
                    return StringValidationHelper.isValidEmail(emailText)
                case .passwordState:
                    return passwordText.characters.count >= 6
                case .signingInState, .welcomeState:
                    return false
                }
            }

        enterButtonTextObservable = currentState.map { $0.enterButtonText }

        didTapEnterButton.withLatestFrom(currentState) { $1 }
            .subscribe(onNext: { [weak self] state in
                switch state {
                case .emailState:
                    self?.currentState.onNext(.passwordState)
                case .passwordState:
                    self?.currentState.onNext(.signingInState)
                case .signingInState, .welcomeState: break
                }
            }).addDisposableTo(disposeBag)

        configureSigningInObserver()
    }

    private func configureSigningInObserver() {
        let minimumFetchingTime = Observable.just(Void.self)
            .delay(2, scheduler: MainScheduler.instance)
        let requestParameters = Observable.combineLatest(
            emailText.asObservable(),
            passwordText.asObservable()) { $0 }

        currenStateObservable
            .filter { $0 == .signingInState }
            .withLatestFrom(requestParameters)
            .flatMap { email, password in
                return Observable.combineLatest(
                    minimumFetchingTime,
                    LoginAPI.loginWithEmail(email: email, password: password)) { $1 }
            }
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    self?.currentState.onNext(.welcomeState)
                case .failure:
                    self?.currentState.onNext(.passwordState)
                    self?.errorDidOccur.onNext()
                }
            }).addDisposableTo(disposeBag)
    }
}

