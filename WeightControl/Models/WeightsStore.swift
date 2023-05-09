import Foundation

final class WeightsStore: WeightsModelProtocol {
    private var dataStore = DataStore()
    func getWeights() -> [Weight] {
        var weights: [Weight] = []
        let rawData = dataStore.getRecords() as [WeightsCoreData]
        rawData.forEach {
            guard let date = $0.date else { return }
            weights.append(Weight(date: date, value: $0.value))
        }
        return weights
    }
    
    func addWeight(weight: Float, date: Date) {
        do {
            let newWeight = WeightsCoreData(context: dataStore.context)
            newWeight.date = date
            newWeight.value = weight
            try dataStore.saveRecord(object: newWeight)
        } catch let error {
            fatalError(error.localizedDescription)
        }
    }
    
    func deleteWeight(indexPath: IndexPath) {
        let record = dataStore.getRecords()[indexPath.row]
        try? dataStore.deleteRecord(object: record)
    }
    
    func editWeight(indexPath: IndexPath, weight: Float, date: Date) {
        let records = dataStore.getRecords()
        guard indexPath.row < records.count,
              let record = records[indexPath.row] as? WeightsCoreData
        else { return }

        record.value = weight
        record.date = date
        
        try? dataStore.saveRecord(object: record)
    }
}
