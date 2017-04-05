import UIKit

class CoreStyle {
    static let color = (
        black: UIColor.black,
        white: UIColor.white,
        transparent: UIColor.clear,
        red: UIColor.red,
        blue: UIColor(rgb: 0x4A8CFA, alphaVal: 1),
        green: UIColor.green,
        yellow: UIColor.yellow,
        gray: UIColor.gray
    )

    static let image = (
        loginBackImage: UIImage(named: "ui_login_back")?.withRenderingMode(.alwaysTemplate),
        loginSpinner: UIImage(named: "ui-login-spinner"),
        loginCheckMark: UIImage(named: "ui_checkmark")
    )

    static let roboto = Roboto()

    static let gutterValue = 20
    static let gutter = (
        left: gutterValue,
        right: -gutterValue,
        top: gutterValue,
        bottom: -gutterValue
    )

}

struct Roboto {
    private struct FontName {
        static let regular = "Roboto-Regular"
        static let medium = "Roboto-Medium"
        static let bold = "Roboto-Bold"
    }

    let regular = UIFont(name: FontName.regular, size: 1)!
    let medium = UIFont(name: FontName.medium, size: 1)!
    let bold = UIFont(name: FontName.bold, size: 1)!
}

