import Foundation

protocol WeightsModelProtocol {
    func getWeights() -> [Weight]
    func addWeight(weight: Float, date: Date)
    func deleteWeight(indexPath: IndexPath)
    func editWeight(indexPath: IndexPath, weight: Float, date: Date)
}
