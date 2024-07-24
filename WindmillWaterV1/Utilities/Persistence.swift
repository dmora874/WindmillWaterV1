import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        // Add sample data for preview
        for _ in 0..<10 {
            let newCustomer = Customer(context: viewContext)
            newCustomer.name = "Sample Customer"
            newCustomer.address = "123 Sample Street"
            newCustomer.phoneNumber = "555-555-5555"
            newCustomer.notes = "Sample notes"
            newCustomer.pricingInformation = "$10 per bottle"
            newCustomer.paymentMethod = "Credit Card"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "WindmillWaterV1")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
