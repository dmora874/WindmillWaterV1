import SwiftUI

struct RoutesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Route.date, ascending: true)],
        animation: .default)
    private var routes: FetchedResults<Route>

    @Environment(\.userRole) var userRole

    var body: some View {
        NavigationView {
            List {
                ForEach(routes) { route in
                    Section(header: Text("Route Date: \(route.date ?? Date(), formatter: itemFormatter)")) {
                        if userRole == .admin {
                            NavigationLink(destination: EditRouteView(route: route)) {
                                Text("Edit Route")
                            }
                            Button(action: {
                                deleteRoute(route)
                            }) {
                                Text("Delete Route")
                                    .foregroundColor(.red)
                            }
                        }

                        if userRole == .deliveryManager || userRole == .admin {
                            if !route.isStarted {
                                Button(action: {
                                    startRoute(route)
                                }) {
                                    Text("Start Route")
                                        .foregroundColor(.blue)
                                }
                            } else if route.isStarted && !route.isCompleted {
                                NavigationLink(destination: ManageDeliveriesView(route: route)) {
                                    Text("Manage Deliveries")
                                }
                                Button(action: {
                                    completeRoute(route)
                                }) {
                                    Text("Complete Route")
                                        .foregroundColor(.green)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Routes")
            .navigationBarItems(trailing: userRole == .admin ? AnyView(NavigationLink("Add Route", destination: AddRouteView())) : AnyView(EmptyView()))
        }
    }

    private func startRoute(_ route: Route) {
        route.isStarted = true
        saveContext()
    }

    private func completeRoute(_ route: Route) {
        route.isCompleted = true
        saveContext()
    }

    private func deleteRoute(_ route: Route) {
        viewContext.delete(route)
        saveContext()
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
            .environment(\.userRole, .admin)
    }
}
