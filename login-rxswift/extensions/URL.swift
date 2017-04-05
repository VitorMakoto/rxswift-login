import Foundation

extension URL {
    static func emptyURL() -> URL {
        return URL(fileURLWithPath: "")
    }
}
