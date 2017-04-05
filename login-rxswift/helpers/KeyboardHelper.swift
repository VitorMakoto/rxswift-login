import UIKit

class KeyboardHelper {
    static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
            to: nil, from: nil, for: nil)
    }
}
