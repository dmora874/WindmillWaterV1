import SwiftUI
import CoreData

struct RoutesView: View {
    @StateObject private var viewModel = RoutesViewModel()
    @Environment(\.userRole) var userRole

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.routes) { route in
                    NavigationLink(destination: RouteDetailView(route: route)) {
                        VStack(alignment: .leading) {
                            Text("Route Date: \(route.date ?? Date(), formatter: itemFormatter)")
                            Text("Status: \(route.isCompleted ? "Completed" : (route.isStarted ? "In Progress" : "Not Started"))")
                                .foregroundColor(route.isCompleted ? .green : (route.isStarted ? .blue : .red))
                        }
                    }
                }
            }
            .navigationTitle("Routes")
            .onAppear {
                viewModel.fetchRoutes()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    if userRole == .admin {
                        NavigationLink(destination: AddRouteView()) {
                            Text("Add Route")
                        }
                    }
                }
            }
        }
    }
}
