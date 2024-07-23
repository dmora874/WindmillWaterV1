import SwiftUI
import CoreData

struct RoutesListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Route.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Route.date, ascending: true)]
    ) var routes: FetchedResults<Route>
    
    @State private var showingAddRouteView = false
    @State private var selectedRoute: Route?
    
    var body: some View {
        List {
            ForEach(routes) { route in
                HStack {
                    Text(route.identifier ?? "Unknown Route")
                    Spacer()
                    Button(action: {
                        selectedRoute = route
                    }) {
                        Text("Edit")
                    }
                }
            }
            .onDelete(perform: deleteRoutes)
        }
        .navigationBarTitle("Routes")
        .navigationBarItems(trailing: Button(action: {
            showingAddRouteView = true
        }) {
            Image(systemName: "plus")
        })
        .sheet(isPresented: $showingAddRouteView) {
            AddRouteView()
        }
        .sheet(item: $selectedRoute) { route in
            EditRouteView(route: route)
        }
    }
    
    private func deleteRoutes(offsets: IndexSet) {
        withAnimation {
            offsets.map { routes[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Handle the error appropriately
            }
        }
    }
}

struct RoutesListView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
