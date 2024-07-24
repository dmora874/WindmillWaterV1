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
                    VStack {
                        Button("Admin Login") {
                            userRole = .admin
                        }

                        Button("Delivery Manager Login") {
                            userRole = .deliveryManager
                        }

                        Button("Warehouse Manager Login") {
                            userRole = .warehouseManager
                        }
                    }
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
                                if userRole == .admin {
                                    Button("Add Sample Customer") {
                                        addSampleCustomer()
                                    }
                                }
                            }
                        }

                        if userRole == .admin || userRole == .deliveryManager {
                            Section(header: Text("Routes")) {
                                ForEach(routes) { route in
                                    NavigationLink(destination: RouteDetailView(route: route)) {
                                        VStack(alignment: .leading) {
                                            Text("Route Date: \(route.date ?? Date(), formatter: itemFormatter)")
                                            Text("Status: \(route.isCompleted ? "Completed" : (route.isStarted ? "In Progress" : "Not Started"))")
                                                .foregroundColor(route.isCompleted ? .green : (route.isStarted ? .blue : .red))
                                        }
                                    }
                                }
                                if userRole == .admin {
                                    Button("Add Sample Route") {
                                        addSampleRoute()
                                    }
                                }
                            }
                        }

                        if userRole == .admin || userRole == .warehouseManager {
                            Section(header: Text("Deliveries")) {
                                if userRole == .admin {
                                    Button("Add Sample Delivery") {
                                        addSampleDelivery()
                                    }
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
            .navigationTitle("Customers")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
