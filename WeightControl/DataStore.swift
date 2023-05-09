import Foundation
import CoreData

final class DataStoreHelper {
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError(error.localizedDescription)
            }
        })
        return container
    }()
}

final class DataStore: NSObject, NSFetchedResultsControllerDelegate {
    let context: NSManagedObjectContext
    
    private lazy var weightsFRC: NSFetchedResultsController<WeightsCoreData> = {
        let fetchRequest = NSFetchRequest<WeightsCoreData>(entityName: "WeightsCoreData")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        let fetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultsController.delegate = self
        try? fetchResultsController.performFetch()
        
        return fetchResultsController
    }()
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    
    override convenience init() {
        let helper = DataStoreHelper()
        self.init(context: helper.persistentContainer.viewContext)
    }
    
    func saveRecord<E: NSManagedObject>(object: E) throws {
        try context.save()
    }
    
    func deleteRecord<E: NSManagedObject>(object: E) throws {
        context.delete(object)
        try context.save()
    }
    
    func getRecords<E: NSManagedObject>() -> [E] {
        try? weightsFRC.performFetch()
        guard let objects = weightsFRC.fetchedObjects as? [E] else { return [] }
        return objects
    }
}
