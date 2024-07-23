import SwiftUI

struct EditRouteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var route: Route
    @State private var selectedCustomers: [Customer] = []

    @FetchRequest(
        entity: Customer.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Customer.name, ascending: true)]
    ) var customers: FetchedResults<Customer>

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Route Details")) {
                    TextField("Identifier", text: Binding(
                        get: { route.identifier ?? "" },
                        set: { route.identifier = $0 }
                    ))
                    DatePicker("Date", selection: Binding(
                        get: { route.date ?? Date() },
                        set: { route.date = $0 }
                    ), displayedComponents: .date)
                }

                Section(header: Text("Customers")) {
                    List {
                        ForEach(customers) { customer in
                            CustomerSelectionRow(customer: customer, isSelected: selectedCustomers.contains(customer)) {
                                if selectedCustomers.contains(customer) {
                                    selectedCustomers.removeAll { $0 == customer }
                                } else {
                                    selectedCustomers.append(customer)
                                }
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Route")
            .navigationBarItems(trailing: Button("Save") {
                editRoute()
            })
            .onAppear {
                if let customers = route.customers as? Set<Customer> {
                    selectedCustomers = Array(customers)
                }
            }
        }
    }

    private func editRoute() {
        route.customers = NSSet(array: selectedCustomers)

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            // Handle the error appropriately
            print("Error saving route: \(error)")
        }
    }
}

struct EditRouteView_Previews: PreviewProvider {
    static var previews: some View {
        EditRouteView(route: Route()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
