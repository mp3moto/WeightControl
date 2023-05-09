import UIKit

enum FontNames: String {
    case SFProDisplaySemibold
    case SFProTextMedium
    case SFProDisplayBold
    case SFProDisplayRegular
}

extension UIFont {
    func getCustomFont(font: FontNames, size: CGFloat) -> UIFont {
        guard let SFProDisplaySemibold = UIFont(name: "SFProDisplay-Semibold", size: size),
              let SFProTextMedium = UIFont(name: "SFProText-Medium", size: size),
              let SFProDisplayBold = UIFont(name: "SFProDisplay-Bold", size: size),
              let SFProDisplayRegular = UIFont(name: "SFProDisplay-Regular", size: size)
        else { return UIFont.systemFont(ofSize: size) }
        switch font {
        case .SFProDisplayBold: return SFProDisplayBold
        case .SFProDisplaySemibold: return SFProDisplaySemibold
        case .SFProTextMedium: return SFProTextMedium
        case .SFProDisplayRegular: return SFProDisplayRegular
        }
    }
}
