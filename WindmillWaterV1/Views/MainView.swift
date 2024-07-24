import SwiftUI

struct MainView: View {
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
                                NavigationLink(destination: CustomersListView()) {
                                    Text("View Customers")
                                }
                                Button("Add Sample Customer") {
                                    addSampleCustomer()
                                }
                            }
                        }

                        if userRole == .admin || userRole == .deliveryManager {
                            Section(header: Text("Routes")) {
                                NavigationLink(destination: RoutesView()) {
                                    Text("View Routes")
                                }
                                Button("Add Sample Route") {
                                    addSampleRoute()
                                }
                            }
                        }

                        if userRole == .admin || userRole == .warehouseManager {
                            Section(header: Text("Deliveries")) {
                                NavigationLink(destination: DeliveriesView()) {
                                    Text("View Deliveries")
                                }
                                Button("Add Sample Delivery") {
                                    addSampleDelivery()
                                }
                            }
                        }

                        if userRole == .admin {
                            Section(header: Text("Products")) {
                                NavigationLink(destination: ManageProductsView()) {
                                    Text("View Products")
                                }
                            }
                        }

                        Button(action: exportCustomers) {
                            Text("Export Customers")
                        }
                    }
                    .listStyle(GroupedListStyle())
                    .navigationBarTitle("Windmill Water Delivery")
                    .navigationBarItems(trailing: Button("Logout") {
                        userRole = nil
                    })
                }
            }
            .padding()
            .navigationTitle("User Role Selection")
        }
        .environment(\.userRole, userRole)
    }

    private func addSampleCustomer() {
        let context = PersistenceController.shared.container.viewContext
        let newCustomer = Customer(context: context)
        newCustomer.name = "John Doe"
        newCustomer.address = "123 Main St"
        newCustomer.phoneNumber = "555-555-5555"
        newCustomer.notes = "Regular delivery"
        newCustomer.pricingInformation = "$10 per bottle"
        newCustomer.paymentMethod = "Credit Card"
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func addSampleRoute() {
        let context = PersistenceController.shared.container.viewContext
        let newRoute = Route(context: context)
        newRoute.date = Date()
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func addSampleDelivery() {
        let context = PersistenceController.shared.container.viewContext
        let newDelivery = Delivery(context: context)
        newDelivery.date = Date()
        newDelivery.customer = try? context.fetch(Customer.fetchRequest()).first
        newDelivery.route = try? context.fetch(Route.fetchRequest()).first
        do {
            try context.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func exportCustomers() {
        let context = PersistenceController.shared.container.viewContext
        let csvData = ExportData.exportCustomers(context: context)
        let fileName = "Customers.csv"
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)

        do {
            try csvData.write(to: path, atomically: true, encoding: String.Encoding.utf8)
            print("Exported CSV to: \(path)")
        } catch {
            print("Failed to write CSV: \(error)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
