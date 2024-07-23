import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Create sample data here for preview
        let sampleCustomer = Customer(context: viewContext)
        sampleCustomer.name = "Sample Customer"
        sampleCustomer.address = "123 Sample Street"
        sampleCustomer.phoneNumber = "123-456-7890"
        sampleCustomer.paymentMethod = "Credit Card"
        sampleCustomer.notes = "Notes about the customer."
        sampleCustomer.pricingInformation = "Pricing details."
        
        let sampleRoute = Route(context: viewContext)
        sampleRoute.identifier = "Sample Route"
        sampleRoute.date = Date()
        sampleRoute.addToCustomers(sampleCustomer)
        
        let sampleProduct = Product(context: viewContext)
        sampleProduct.name = "Sample Product"
        sampleProduct.price = "10.00"
        
        let sampleDelivery = Delivery(context: viewContext)
        sampleDelivery.date = Date()
        sampleDelivery.quantityDelivered = 5
        sampleDelivery.quantityReturned = 1
        sampleDelivery.notes = "Delivery notes."
        sampleDelivery.customer = sampleCustomer
        sampleDelivery.route = sampleRoute
        sampleDelivery.addToProducts(sampleProduct)
        
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
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (description, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
