//
//  LoginViewController.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import Foundation
import SwiftyJSON

enum ResultsItemType: String {
    case token = "TOKEN"
    case unknown = "UNKNOWN"

    func resultItem(json: JSON) -> ResultsItem? {
        switch self {
        case .token:
            return TokenItem.decode(json: json)
        case .unknown:
            return nil
        }
    }
}

protocol ResultsItem {
    func itemType() -> ResultsItemType
    static func decode(json: JSON) -> ResultsItem?
}
