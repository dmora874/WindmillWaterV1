import SwiftUI
import CoreData

struct RoutesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Route.date, ascending: true)],
        animation: .default)
    private var routes: FetchedResults<Route>
    
    @Environment(\.userRole) private var userRole

    var body: some View {
        List {
            ForEach(routes) { route in
                NavigationLink(destination: RouteDetailView(route: route)) {
                    VStack(alignment: .leading) {
                        Text("Route Date: \(route.date ?? Date(), formatter: itemFormatter)")
                        Text("Status: \(route.isStarted ? "In Progress" : route.isCompleted ? "Completed" : "Not Started")")
                            .foregroundColor(route.isStarted ? .blue : route.isCompleted ? .green : .red)
                    }
                }
            }
            .onDelete(perform: deleteRoutes)
        }
        .navigationBarTitle("Routes")
        .navigationBarItems(trailing: userRole == .admin ? EditButton() : nil)
    }

    private func deleteRoutes(offsets: IndexSet) {
        withAnimation {
            offsets.map { routes[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
