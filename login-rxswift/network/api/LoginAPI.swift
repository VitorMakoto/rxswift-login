//
//  LoginViewController.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import Argo

enum LoginError: Swift.Error {
    case loginWithhEmailOrCPFError(LoginWithEmailOrCPFErrorType)
}

enum LoginWithEmailOrCPFErrorType: String {
    case noTokenProvided = "NO_TOKEN_PROVIDED"
    case registerNotFound = "REGISTROS_NAO_ENCONTRADOS"
    case blockedPassword = "SENHA_BLOQUEADA"
    case expiredPassword = "SENHA_EXPIRADA"
    case badGateway = "BAD_GATEWAY"
    case gatewayTimeout = "GATEWAY_TIMEOUT"
    case badRequest = "BAD_REQUEST"
}

class LoginAPI {
    private static let provider = RxMoyaProvider<LoginService>()

    static func loginWithEmail(email: String, password: String) -> Observable<Result<TokenItem>> {
        return LoginAPI.provider
            .request(.loginWithEmail(email: email, password: password))
            .mapJSON()
            .map { JSON($0) }
            .map { APIParser.parseResults(json: $0,
                onStatusErrorHandler: { status in
                    guard let loginErrorType = LoginWithEmailOrCPFErrorType(rawValue: status) else {
                        return Result.failure(APIError.unknown)
                    }

                    return Result.failure(LoginError.loginWithhEmailOrCPFError(loginErrorType))
            }) }
            .map { results in
                switch results {
                case .success(let items):
                    let wrappedToken = items
                        .filter { $0.itemType() == .token }
                        .first as? TokenItem
                    guard let tokenItem = wrappedToken else {
                        return Result.failure(
                            LoginError.loginWithhEmailOrCPFError(.noTokenProvided))
                    }

                    return Result.success(tokenItem)
                case .failure(let error):
                    return Result.failure(error)
                }
            }
            .catchErrorJustReturn(Result.failure(APIError.unknown))
    }
}
