import UIKit

extension UIColor {
    convenience init(rgb: UInt, alphaVal: CGFloat) {
        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alphaVal)
        )
    }

    convenience init(hexCode: String, alphaVal: CGFloat = CGFloat(1)) {

        let bareCode = hexCode.replacingOccurrences(of: "#", with: "")
        let scanner = Scanner(string: bareCode)

        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)

        self.init(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alphaVal)
        )
    }

    convenience init(color: UIColor, alphaVal: CGFloat) {
        self.init(
            red: color.redColor,
            green: color.greenColor,
            blue: color.blueColor,
            alpha: alphaVal
        )
    }

    static func randomColor() -> UIColor {
        return UIColor(hue: CGFloat(Float(arc4random()) / Float(UINT32_MAX)), saturation: 1,
                       brightness: 1, alpha: 1)
    }

    var redColor: CGFloat {
        var value: CGFloat = 0
        getRed(&value, green: nil, blue: nil, alpha: nil)
        return value
    }

    var greenColor: CGFloat {
        var value: CGFloat = 0
        getRed(nil, green: &value, blue: nil, alpha: nil)
        return value
    }

    var blueColor: CGFloat {
        var value: CGFloat = 0
        getRed(nil, green: nil, blue: &value, alpha: nil)
        return value
    }

    var alpha: CGFloat {
        var value: CGFloat = 0
        getRed(nil, green: nil, blue: nil, alpha: &value)
        return value
    }
}

