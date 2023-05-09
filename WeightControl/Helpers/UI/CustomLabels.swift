import UIKit

enum LabelStyles: String {
    case title
    case widgetTitle
    case weightValue
    case weightDifference
    case measurementSystemLabel
    case toast
    case tableHeader
    case weightUnits
    case dateLabel
}

extension UILabel {
    func customStyle(style: LabelStyles, text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        switch style {
        case .title:
            label.font = UIFont().getCustomFont(font: .SFProDisplaySemibold, size: 20)
            label.textColor = UIColor().getProjectUIColor(color: .wchngBlack)
        case .widgetTitle:
            label.font = UIFont().getCustomFont(font: .SFProTextMedium, size: 13)
            label.textColor = UIColor().getProjectUIColor(color: .black40)
        case .weightValue:
            label.font = UIFont().getCustomFont(font: .SFProTextMedium, size: 22)
            label.textColor = UIColor().getProjectUIColor(color: .wchngBlack)
        case .weightDifference:
            label.font = UIFont().getCustomFont(font: .SFProTextMedium, size: 17)
            label.textColor = UIColor().getProjectUIColor(color: .black60)
        case .measurementSystemLabel:
            label.font = UIFont().getCustomFont(font: .SFProTextMedium, size: 17)
            label.textColor = UIColor().getProjectUIColor(color: .wchngBlack)
        case .toast:
            label.font = UIFont().getCustomFont(font: .SFProTextMedium, size: 15)
            label.textColor = UIColor().getProjectUIColor(color: .toastText)
        case .tableHeader:
            label.font = UIFont().getCustomFont(font: .SFProTextMedium, size: 13)
            label.textColor = UIColor().getProjectUIColor(color: .black40)
        case .weightUnits:
            label.font = UIFont().getCustomFont(font: .SFProTextMedium, size: 17)
            label.textColor = UIColor().getProjectUIColor(color: .black40)
        case .dateLabel:
            label.font = UIFont().getCustomFont(font: .SFProDisplayRegular, size: 17)
            label.textColor = UIColor().getProjectUIColor(color: .black40)
        }
        return label
    }
    
    
}
