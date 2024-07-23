import SwiftUI

struct AddRouteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

    @FetchRequest(
        entity: Customer.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Customer.name, ascending: true)]
    ) var customers: FetchedResults<Customer>

    @State private var identifier: String = ""
    @State private var date: Date = Date()
    @State private var selectedCustomers: [Customer] = []

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Route Details")) {
                    TextField("Identifier", text: $identifier)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
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
            .navigationBarTitle("Add Route")
            .navigationBarItems(trailing: Button("Save") {
                addRoute()
            })
        }
    }

    private func addRoute() {
        let newRoute = Route(context: viewContext)
        newRoute.identifier = identifier
        newRoute.date = date
        newRoute.customers = NSSet(array: selectedCustomers)

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            // Handle the error appropriately
            print("Error saving route: \(error)")
        }
    }
}

struct AddRouteView_Previews: PreviewProvider {
    static var previews: some View {
        AddRouteView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
