//
//  LoginSpinner.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 4/3/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import UIKit

class LoginSpinnerView: UIView {
    private struct Constants {
        static let spinnerLineWidth: CGFloat = 3
        static let spinnerSize = CGSize(width: 24, height: 24)
        static let checkMarkSize = CGSize(width: 24, height: 18)
        static let spinnerFadeInDuration = 0.2
        static let spinnerFadeOutDuration = 0.3
        static let spinnerScaleInDuration = 0.2
        static let spinnerScaleOutDuration = 0.3
        static let checkMarkFadeInDuration = 0.3
        static let checkMarkScaleInDuration = 0.3
    }

    private let spinnerLayer = CALayer()
    private let checkMarkLayer = CALayer()

    override init(frame: CGRect) {
        super.init(frame: frame)

        loadContent()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadContent() {
        var innerFrame = CGRect(origin: .zero, size: Constants.spinnerSize)
        innerFrame.center = center

        spinnerLayer.opacity = 0
        spinnerLayer.frame = innerFrame
        spinnerLayer.contents = CoreStyle.image.loginSpinner?
            .maskWithColor(color: CoreStyle.color.blue)?.cgImage
        spinnerLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        checkMarkLayer.frame.size = Constants.checkMarkSize
        checkMarkLayer.frame.center = innerFrame.center
        checkMarkLayer.contents = CoreStyle.image.loginCheckMark?
            .maskWithColor(color: CoreStyle.color.blue)?.cgImage
        checkMarkLayer.opacity = 0
        checkMarkLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        layer.addSublayer(checkMarkLayer)
        layer.addSublayer(spinnerLayer)
    }

    func reset() {
        spinnerLayer.opacity = 0
        checkMarkLayer.opacity = 0

        spinnerLayer.removeAllAnimations()
        checkMarkLayer.removeAllAnimations()
    }

    func startLoading() {
        let spinnerFadeInAnim = CABasicAnimation(keyPath: "opacity")
        spinnerFadeInAnim.duration = Constants.spinnerFadeInDuration
        spinnerFadeInAnim.toValue = 1
        spinnerFadeInAnim.fillMode = kCAFillModeForwards
        spinnerFadeInAnim.isRemovedOnCompletion = false
        spinnerFadeInAnim.timingFunction =
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        let initialRotation = NSNumber(value: Float(-50 * CGFloat.pi / 180))
        let finalRotation = NSNumber(value: Float(310 * CGFloat.pi / 180))

        let spinnerRotationAnimKeyFrames: [NSNumber] =
            [initialRotation, finalRotation, finalRotation]
        let spinnerRotationAnimKeyTimes: [NSNumber] = [0, 0.8, 1.0]
        let spinnerRotationAnimTimingFunctions = [
            CAMediaTimingFunction(controlPoints: 0.72, 0.01, 0.27, 1),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear),
            CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        ]

        let spinnerRotationAnim = CAKeyframeAnimation()
        spinnerRotationAnim.keyPath = "transform.rotation.z"
        spinnerRotationAnim.values = spinnerRotationAnimKeyFrames
        spinnerRotationAnim.keyTimes = spinnerRotationAnimKeyTimes
        spinnerRotationAnim.timingFunctions = spinnerRotationAnimTimingFunctions
        spinnerRotationAnim.duration = 0.7
        spinnerRotationAnim.autoreverses = false
        spinnerRotationAnim.isRemovedOnCompletion = false
        spinnerRotationAnim.repeatCount = .infinity

        let spinnerScaleInAnim = CABasicAnimation(keyPath: "transform.scale")
        spinnerScaleInAnim.duration = Constants.spinnerFadeInDuration
        spinnerScaleInAnim.isRemovedOnCompletion = false
        spinnerScaleInAnim.fromValue = 0.3
        spinnerScaleInAnim.toValue = 1
        spinnerScaleInAnim.fillMode = kCAFillModeForwards
        spinnerScaleInAnim.timingFunction =
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        spinnerLayer.add(spinnerFadeInAnim, forKey: "spinner-fadein")
        spinnerLayer.add(spinnerRotationAnim, forKey: "spinner-rot")
        spinnerLayer.add(spinnerScaleInAnim, forKey: "spinner-scalein")
    }

    func done() {
        let spinnerFadeOutAnim = CABasicAnimation(keyPath: "opacity")
        spinnerFadeOutAnim.duration = Constants.spinnerFadeOutDuration
        spinnerFadeOutAnim.toValue = 0
        spinnerFadeOutAnim.isRemovedOnCompletion = false
        spinnerFadeOutAnim.fillMode = kCAFillModeForwards

        let spinnerScaleOutAnim = CABasicAnimation(keyPath: "transform.scale")
        spinnerScaleOutAnim.duration = Constants.spinnerScaleOutDuration
        spinnerScaleOutAnim.toValue = 1.2
        spinnerScaleOutAnim.isRemovedOnCompletion = false
        spinnerScaleOutAnim.fillMode = kCAFillModeForwards
        spinnerScaleOutAnim.timingFunction =
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        spinnerLayer.add(spinnerFadeOutAnim, forKey: "spinner-fadeout")
        spinnerLayer.add(spinnerScaleOutAnim, forKey: "spinner-scaleout")

        let checkMarkFadeInAnim = CABasicAnimation(keyPath: "opacity")
        checkMarkFadeInAnim.beginTime = CACurrentMediaTime() + Constants.spinnerFadeOutDuration
        checkMarkFadeInAnim.duration = Constants.checkMarkFadeInDuration
        checkMarkFadeInAnim.toValue = 1
        checkMarkFadeInAnim.isRemovedOnCompletion = false
        checkMarkFadeInAnim.fillMode = kCAFillModeForwards

        let checkMarkScaleInAnim = CABasicAnimation(keyPath: "transform.scale")
        checkMarkScaleInAnim.beginTime = CACurrentMediaTime() + Constants.spinnerFadeOutDuration
        checkMarkScaleInAnim.duration = Constants.checkMarkScaleInDuration
        checkMarkScaleInAnim.fromValue = 0.3
        checkMarkScaleInAnim.toValue = 1
        checkMarkScaleInAnim.isRemovedOnCompletion = false
        checkMarkScaleInAnim.fillMode = kCAFillModeForwards
        checkMarkScaleInAnim.timingFunction =
            CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)

        checkMarkLayer.add(checkMarkFadeInAnim, forKey: "checkmark-fadein")
        checkMarkLayer.add(checkMarkScaleInAnim, forKey: "checkmark-scalein")
    }

    func fadeOut() {
        let spinnerFadeOutAnim = CABasicAnimation(keyPath: "opacity")
        spinnerFadeOutAnim.duration = Constants.spinnerFadeOutDuration
        spinnerFadeOutAnim.toValue = 0
        spinnerFadeOutAnim.isRemovedOnCompletion = false
        spinnerFadeOutAnim.fillMode = kCAFillModeForwards
        
        spinnerLayer.add(spinnerFadeOutAnim, forKey: "spinner-force-fadeout")
    }
}
