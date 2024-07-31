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
                        VStack(alignment: .leading, spacing: 5) {
                            Text(route.identifier ?? "Unknown Identifier")
                                .font(.headline)
                                .foregroundColor(.black)
                            Text("Date: \(route.date ?? Date(), formatter: itemFormatter)")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                            Text("Status: \(routeStatusText(route: route))")
                                .font(.subheadline)
                                .foregroundColor(routeStatusColor(route: route))
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(8)
                        .shadow(radius: 2)
                    }
                }
            }
            .listStyle(PlainListStyle())
            .navigationBarTitle("Routes", displayMode: .inline)
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        }
    }

    private func routeStatusText(route: Route) -> String {
        if route.isCompleted {
            return "Completed"
        } else if route.isStarted {
            return "In Progress"
        } else {
            return "Not Started"
        }
    }

    private func routeStatusColor(route: Route) -> Color {
        if route.isCompleted {
            return .green
        } else if route.isStarted {
            return .blue
        } else {
            return .red
        }
    }
}

struct RoutesListView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
