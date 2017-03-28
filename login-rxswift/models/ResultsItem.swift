//
//  LoginViewController.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import Foundation
import Argo

enum ResultsItemType: String {
    case token = "TOKEN"
    case unknown = "UNKNOWN"

    func resultItem(json: JSON) -> ResultsItem? {
        switch self {
        case .token:
            return TokenItem.decode(json).value
        case .unknown:
            return nil
        }
    }
}

protocol ResultsItem {
    func itemType() -> ResultsItemType
}
