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

    var body: some View {
        NavigationView {
            VStack {
                List {
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
                }
                Button("Add Sample Customer") {
                    addSampleCustomer()
                }
                Button("Add Sample Route") {
                    addSampleRoute()
                }
                Button("Add Sample Delivery") {
                    addSampleDelivery()
                }
                NavigationLink(destination: RoutesView()) {
                    Text("Manage Routes")
                }
                NavigationLink(destination: DeliveriesView()) {
                    Text("Manage Deliveries")
                }
            }
            .padding()
            .navigationTitle("Customers")
        }
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
