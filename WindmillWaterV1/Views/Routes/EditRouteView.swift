import SwiftUI
import CoreData

struct EditRouteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var route: Route
    @State private var identifier: String
    @State private var date: Date
    @State private var selectedCustomers: Set<Customer> = []

    @FetchRequest(
        entity: Customer.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Customer.name, ascending: true)]
    ) var customers: FetchedResults<Customer>

    init(route: Route) {
        self.route = route
        _identifier = State(initialValue: route.identifier ?? "")
        _date = State(initialValue: route.date ?? Date())
        if let customers = route.customers as? Set<Customer> {
            _selectedCustomers = State(initialValue: customers)
        }
    }

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Route Details")) {
                    TextField("Identifier", text: $identifier)
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                }
            }

            Form {
                Section(header: Text("Customers")) {
                    List {
                        ForEach(customers, id: \.self) { customer in
                            CustomerSelectionRow(customer: customer, isSelected: selectedCustomers.contains(customer)) {
                                if selectedCustomers.contains(customer) {
                                    selectedCustomers.remove(customer)
                                } else {
                                    selectedCustomers.insert(customer)
                                }
                            }
                        }
                    }
                }
            }

            Button("Save") {
                route.identifier = identifier
                route.date = date
                route.customers = NSSet(set: selectedCustomers)
                saveContext()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .navigationBarTitle("Edit Route")
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

struct EditRouteView_Previews: PreviewProvider {
    static var previews: some View {
        EditRouteView(route: Route()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
