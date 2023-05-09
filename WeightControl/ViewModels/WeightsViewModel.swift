import Foundation

final class WeightsViewModel {
    var onWeightsUpdate: (() -> Void)?
    var model: WeightsModelProtocol
    var lastWeight: WeightViewModel?
    var units: String = Const.kg
    var convertionK: Float? {
        didSet {
            if convertionK == 1.0 {
                units = Const.kg
            } else {
                units = Const.ft
            }
            updateWeights()
        }
    }
    private var weightViewModels = [WeightViewModel]() {
        didSet {
            onWeightsUpdate?()
        }
    }
    
    init(model: WeightsModelProtocol) {
        self.model = model
        updateWeights()
    }
    
    func updateWeights() {
        let weights = model.getWeights().reversed()
        var tempArray: [WeightViewModel] = []
        var prevWeight: Float?
        var difference: Float = 0.0
        
        weights.forEach {
            let convertedValue = $0.value * (convertionK ?? 1.0)
            if let previousWeight = prevWeight {
                difference = convertedValue - previousWeight
            }
            let weightViewModel = WeightViewModel(weight: convertedValue, difference: difference, date: $0.date)
            weightViewModel.units = units
            tempArray.append(weightViewModel)
            lastWeight = weightViewModel
            prevWeight = convertedValue
        }
        
        weightViewModels = tempArray.reversed()
    }
    
    func weightsCount() -> Int {
        return model.getWeights().count
    }
    
    func getCellViewModel(at: IndexPath) -> WeightViewModel {
        weightViewModels[at.row]
    }
    
    func addWeight(weight: Float, date: Date) {
        guard let convertionK = convertionK,
              weight > 0
        else { return }
        model.addWeight(weight: weight / convertionK, date: date)
    }
    
    func deleteWeight(indexPath: IndexPath) {
        model.deleteWeight(indexPath: indexPath)
        updateWeights()
    }
    
    func editWeight(indexPath: IndexPath, weight: Float, date: Date) {
        guard let convertionK = convertionK,
              weight > 0
        else { return }
        model.editWeight(indexPath: indexPath, weight: weight / convertionK, date: date)
        updateWeights()
    }
    
    func getWeight(indexPath: IndexPath) -> Weight {
        model.getWeights()[indexPath.row]
    }
}
