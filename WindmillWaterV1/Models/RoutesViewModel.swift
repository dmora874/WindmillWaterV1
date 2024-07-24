import SwiftUI
import CoreData

class RoutesViewModel: ObservableObject {
    @Published var routes: [Route] = []

    func fetchRoutes() {
        let context = PersistenceController.shared.container.viewContext
        let request: NSFetchRequest<Route> = Route.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Route.date, ascending: true)]

        do {
            routes = try context.fetch(request)
        } catch {
            print("Failed to fetch routes: \(error)")
        }
    }
}
