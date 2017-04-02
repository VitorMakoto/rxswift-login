//
//  LoginViewController.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TokenItem {
    let token: String
}

extension TokenItem: ResultsItem {
    private struct Keys {
        static let token = "token"
    }

    func itemType() -> ResultsItemType {
        return .token
    }

    static func decode(json: JSON) -> ResultsItem? {
        guard let token = json[Keys.token].string else {
            return nil
        }

        return TokenItem(token: token)
    }
}
