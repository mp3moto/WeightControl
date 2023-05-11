import UIKit

final class WCHNGButton: UIButton {
    override var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? UIColor().getProjectUIColor(color: .wchngPurple) : UIColor().getProjectUIColor(color: .wchngGray)
        }
    }
}
