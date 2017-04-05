import UIKit
import SnapKit

class LoginPasswordTitle: UIView {
    private struct Constants {
        static let passwordText = "Agora digite a senha:"
    }
    let backButton = UIButton()
    private let title = UILabel()

    init() {
        super.init(frame: CGRect.zero)

        loadContent()
        makeLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func loadContent() {
        backButton.setImage(CoreStyle.image.loginBackImage, for: .normal)
        backButton.tintColor = CoreStyle.color.blue

        title.text = Constants.passwordText
        title.textAlignment = .left
        title.font = CoreStyle.roboto.bold.withSize(20)
        title.textColor = CoreStyle.color.blue

        addSubview(backButton)
        addSubview(title)
    }

    private func makeLayout() {
        backButton.snp.makeConstraints { make in
            make.centerY.equalTo(title.snp.centerY)
            make.left.equalToSuperview().offset(0)
            make.height.equalTo(20)
            make.width.equalTo(13)
        }
        title.snp.makeConstraints { make in
            make.top.bottom.equalTo(0)
            make.left.equalToSuperview().offset(CoreStyle.gutter.left)
            make.right.equalToSuperview().offset(CoreStyle.gutter.right)
        }
    }
}
