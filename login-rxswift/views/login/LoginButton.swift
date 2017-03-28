//
//  LoginButton.swift
//  login-rxswift
//
//  Created by Vitor Makoto on 3/27/17.
//  Copyright © 2017 Work&Co. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginButton: UIButton {
    var text: String {
        get {
            return title(for: .normal) ?? ""
        }
        set {
            setTitle(newValue, for: .normal)
        }
    }

    var heightConstraint: Constraint?

    init() {
        super.init(frame: .zero)

        loadContent()
        makeLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadContent() {
        backgroundColor = CoreStyle.color.blue

        layer.cornerRadius = 3

        setTitleColor(UIColor(color: CoreStyle.color.black, alphaVal: 0.2), for: .disabled)
        setTitleColor(CoreStyle.color.white, for: .normal)
        setTitleColor(UIColor(color: CoreStyle.color.black, alphaVal: 0.3), for: .highlighted)
        titleLabel?.font = CoreStyle.roboto.bold.withSize(14)
    }

    func makeLayout() {
        snp.makeConstraints { make in
            make.height.equalTo(70)
        }
    }
}
