import SwiftUI

struct RoutesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Route.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Route.date, ascending: true)]
    ) var routes: FetchedResults<Route>

    var body: some View {
        NavigationView {
            List {
                ForEach(routes) { route in
                    NavigationLink(destination: RouteDetailView(route: route)) {
                        VStack(alignment: .leading) {
                            Text("Identifier: \(route.identifier ?? "")")
                            Text("Date: \(route.date ?? Date(), formatter: itemFormatter)")
                            Text("Status: \(route.isCompleted ? "Completed" : (route.isStarted ? "In Progress" : "Not Started"))")
                                .foregroundColor(route.isCompleted ? .green : (route.isStarted ? .blue : .red))
                        }
                    }
                }
            }
            .navigationBarTitle("Routes")
        }
    }
}
