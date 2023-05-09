import Foundation

extension Date {
    func prepareDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let shortDate = dateFormatter.string(from: self)
        let longDate = "\(shortDate)T00:00:00+0000"
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let result = dateFormatter.date(from: longDate) {
            return result
        } else {
            return nil
        }
    }
    func displayDate() -> String {
        guard let now = Date().prepareDate() else { return "" }
        if self.prepareDate() == now {
            return "Сегодня"
        } else {
            let dateFormatter = DateFormatter()
            let calendar = Calendar.current
            var components = calendar.dateComponents([.year], from: now)
            let currentYear = components.year
            components = calendar.dateComponents([.year], from: self)
            let year = components.year
            if currentYear == year {
                dateFormatter.dateFormat = "d MMM"
            } else {
                dateFormatter.dateFormat = "dd.MM.yy"
            }
            dateFormatter.locale = Locale.current
            return dateFormatter.string(from: self)
        }
    }
}
