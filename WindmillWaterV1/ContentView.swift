import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Customer.name, ascending: true)],
        animation: .default)
    private var customers: FetchedResults<Customer>
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Route.date, ascending: true)],
        animation: .default)
    private var routes: FetchedResults<Route>

    @State private var userRole: UserRole? = nil

    var body: some View {
        NavigationView {
            VStack {
                if userRole == nil {
                    VStack(spacing: 20) {
                        Button(action: {
                            userRole = .admin
                        }) {
                            Text("Admin Login")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            userRole = .deliveryManager
                        }) {
                            Text("Delivery Manager Login")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }

                        Button(action: {
                            userRole = .warehouseManager
                        }) {
                            Text("Warehouse Manager Login")
                                .font(.title2)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    .padding()
                } else {
                    List {
                        if userRole == .admin || userRole == .deliveryManager {
                            Section(header: Text("Customers")) {
                                ForEach(customers) { customer in
                                    VStack(alignment: .leading) {
                                        Text("Name: \(customer.name ?? "Unknown")")
                                        Text("Address: \(customer.address ?? "Unknown")")
                                        Text("Phone: \(customer.phoneNumber ?? "Unknown")")
                                        Text("Notes: \(customer.notes ?? "Unknown")")
                                        Text("Pricing: \(customer.pricingInformation ?? "Unknown")")
                                        Text("Payment: \(customer.paymentMethod ?? "Unknown")")
                                    }
                                }
                                Button(action: addSampleCustomer) {
                                    Text("Add Sample Customer")
                                        .foregroundColor(.blue)
                                }
                            }
                        }

                        if userRole == .admin || userRole == .deliveryManager {
                            Section(header: Text("Routes")) {
                                ForEach(routes) { route in
                                    VStack(alignment: .leading) {
                                        Text("Route Date: \(route.date ?? Date(), formatter: itemFormatter)")
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
                                if userRole == .admin {
                                    Button(action: addSampleRoute) {
                                        Text("Add Sample Route")
                                            .foregroundColor(.blue)
                                    }
                                }
                                NavigationLink(destination: RoutesView()) {
                                    Text("Manage Routes")
                                }
                            }
                        }

                        if userRole == .admin || userRole == .warehouseManager {
                            Section(header: Text("Deliveries")) {
                                Button(action: addSampleDelivery) {
                                    Text("Add Sample Delivery")
                                        .foregroundColor(.blue)
                                }
                                NavigationLink(destination: DeliveriesView()) {
                                    Text("Manage Deliveries")
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .navigationTitle("Windmill Water Delivery")
        }
        .environment(\.userRole, userRole)
    }

    private func addSampleCustomer() {
        let newCustomer = Customer(context: viewContext)
        newCustomer.name = "John Doe"
        newCustomer.address = "123 Main St"
        newCustomer.phoneNumber = "555-555-5555"
        newCustomer.notes = "Regular delivery"
        newCustomer.pricingInformation = "$10 per bottle"
        newCustomer.paymentMethod = "Credit Card"
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func addSampleRoute() {
        let newRoute = Route(context: viewContext)
        newRoute.date = Date()
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func addSampleDelivery() {
        let newDelivery = Delivery(context: viewContext)
        newDelivery.date = Date()
        newDelivery.customer = customers.first
        newDelivery.route = routes.first
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteRoute(_ route: Route) {
        viewContext.delete(route)
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
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

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
