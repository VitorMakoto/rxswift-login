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
