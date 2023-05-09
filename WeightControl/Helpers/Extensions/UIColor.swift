import UIKit

enum ProjectColors: String {
    case black40
    case black60
    case separator
    case tableHeaderSeparator
    case toastText
    case wchngBlack
    case wchngGray
    case wchngPurple
    case wchngWidget
}

extension UIColor {
    func getProjectUIColor(color: ProjectColors) -> UIColor {
        var colorName = ""
        switch color {
        case .black40: colorName = "Black40"
        case .black60: colorName = "Black60"
        case .separator: colorName = "Separator"
        case .tableHeaderSeparator: colorName = "TableHeaderSeparator"
        case .toastText: colorName = "ToastText"
        case .wchngBlack: colorName = "WCHNGBlack"
        case .wchngGray: colorName = "WCHNGGray"
        case .wchngPurple: colorName = "WCHNGPurple"
        case .wchngWidget: colorName = "WCHNGWidget"
        }
        return UIColor(named: colorName) ?? UIColor.black
    }
}
