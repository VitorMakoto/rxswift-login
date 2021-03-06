import CoreGraphics

extension CGRect {
    var center: CGPoint {
        get {
            return CGPoint(x: centerX, y: centerY)
        }
        set {
            centerX = newValue.x
            centerY = newValue.y
        }
    }

    var centerX: CGFloat {
        get {
            return origin.x + size.width / 2
        }
        set {
            origin.x = newValue - size.width / 2
        }
    }

    var centerY: CGFloat {
        get {
            return origin.y + size.height / 2
        }
        set {
            origin.y = newValue - size.height / 2
        }
    }
}
