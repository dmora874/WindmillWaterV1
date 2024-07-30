import SwiftUI
import CoreData

struct DeliveriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Route.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Route.date, ascending: true)],
        predicate: NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
    ) var completedRoutes: FetchedResults<Route>

    var body: some View {
        NavigationView {
            List {
                ForEach(completedRoutes) { route in
                    NavigationLink(destination: DeliveryDetailView(route: route)) {
                        VStack(alignment: .leading) {
                            Text("Route Date: \(route.date ?? Date(), formatter: itemFormatter)")
                            ForEach(route.customersArray, id: \.self) { customer in
                                Text("Customer: \(customer.name ?? "Unknown")")
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Deliveries")
        }
    }
}
