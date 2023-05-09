import Foundation

final class WeightsStoreMock: WeightsModelProtocol {
    
    private var weights: [Weight] = []
    
    func getWeights() -> [Weight] {
        weights
    }
    
    func deleteWeight(indexPath: IndexPath) {
        weights.remove(at: indexPath.row)
    }
    
    func editWeight(indexPath: IndexPath, weight: Float, date: Date) {
        weights[indexPath.row] = Weight(date: date, value: weight)
    }
    
    func addWeight(weight: Float, date: Date) {
        weights.append(
            Weight(date: date, value: weight)
        )
    }
}
