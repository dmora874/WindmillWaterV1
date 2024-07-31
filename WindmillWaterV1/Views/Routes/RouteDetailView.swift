import SwiftUI

struct RouteDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.userRole) var userRole
    @ObservedObject var route: Route
    @State private var showEditRoute = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Route Details")
                        .font(.headline)
                        .padding(.bottom, 5)

                    HStack {
                        Text("Identifier:")
                            .bold()
                        Spacer()
                        Text(route.identifier ?? "")
                    }
                    HStack {
                        Text("Date:")
                            .bold()
                        Spacer()
                        Text("\(route.date ?? Date(), formatter: itemFormatter)")
                    }
                    HStack {
                        Text("Status:")
                            .bold()
                        Spacer()
                        Text(route.isCompleted ? "Completed" : (route.isStarted ? "In Progress" : "Not Started"))
                            .foregroundColor(route.isCompleted ? .green : (route.isStarted ? .blue : .red))
                    }

                    if userRole == .deliveryManager {
                        NavigationLink(destination: DeliverySummaryView(route: route)) {
                            Text("View Summary")
                                .font(.headline)
                                .foregroundColor(.blue)
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

                if userRole == .deliveryManager {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Customers")
                            .font(.headline)
                            .padding(.bottom, 5)

                        ForEach(route.customersList, id: \.self) { customer in
                            VStack(alignment: .leading) {
                                Text("Name: \(customer.name ?? "Unknown")")
                                    .font(.headline)
                                Text("Address: \(customer.address ?? "Unknown")")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                NavigationLink(destination: CustomerDetailView(customer: customer, route: route)) {
                                    Text("Details")
                                        .font(.subheadline)
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding(.vertical, 5)
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                if userRole == .admin {
                    VStack(spacing: 10) {
                        NavigationLink(destination: EditRouteView(route: route), isActive: $showEditRoute) {
                            Text("Edit Route")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.gray.opacity(0.2))
                                .foregroundColor(.black)
                                .cornerRadius(10)
                        }

                        Button("Delete Route") {
                            deleteRoute()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                    }
                    .padding()
                }

                if userRole == .deliveryManager {
                    VStack(spacing: 10) {
                        if !route.isStarted {
                            Button("Start Route") {
                                route.isStarted = true
                                saveContext()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        } else if route.isStarted && !route.isCompleted {
                            Button("Complete Route") {
                                route.isCompleted = true
                                saveContext()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        }
                    }
                    .padding()
                }
            }
            .padding()
        }
        .navigationBarTitle("Route Details", displayMode: .inline)
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteRoute() {
        viewContext.delete(route)
        saveContext()
        presentationMode.wrappedValue.dismiss()
    }
}

// Helper extension to convert NSSet to array
extension Route {
    var customersList: [Customer] {
        let set = customers as? Set<Customer> ?? []
        return Array(set)
    }
}

struct RouteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let route = Route(context: context)
        route.identifier = "Test Route"
        route.date = Date()
        return RouteDetailView(route: route).environment(\.managedObjectContext, context)
    }
}
