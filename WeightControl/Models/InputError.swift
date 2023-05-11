import Foundation

enum InputError: Error {
    case invalidValue
    
    var localizedDescription: String {
        switch self {
        case .invalidValue: return Const.invalidInputErrorMessage
        }
    }
}
