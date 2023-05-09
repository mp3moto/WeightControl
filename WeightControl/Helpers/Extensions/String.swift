import Foundation

extension String {
    var floatValue: Float? {
        Float(self.replacingOccurrences(of: ",", with: "."))
    }
}
