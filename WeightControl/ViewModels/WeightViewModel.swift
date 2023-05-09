import Foundation

final class WeightViewModel {
    var units: String?
    private(set) var weight: Float
    private(set) var difference: Float
    private(set) var date: Date
    
    init(weight: Float, difference: Float, date: Date) {
        self.weight = weight
        self.difference = difference
        self.date = date
    }
}
