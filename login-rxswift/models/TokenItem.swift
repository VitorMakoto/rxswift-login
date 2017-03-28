//
//  LoginViewController.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import Foundation
import Argo
import Curry
import Runes

struct TokenItem: ResultsItem {
    let token: String

    func itemType() -> ResultsItemType {
        return .token
    }
}

extension TokenItem: Decodable {
    private struct Keys {
        static let token = "token"
    }

    public static func decode(_ json: JSON) -> Decoded<TokenItem> {
        return curry(self.init)
            <^> json <| Keys.token
    }
}
