import SwiftUI
import CoreData

struct EditRouteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var route: Route
    @State private var identifier: String
    @State private var date: Date
    @State private var selectedCustomers: Set<Customer> = []
    @State private var searchText: String = ""

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
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Route Details")
                        .font(.headline)
                        .padding(.bottom, 5)

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Identifier")
                            .bold()
                        TextField("Identifier", text: $identifier)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding(.bottom, 10)
                    }

                    VStack(alignment: .leading, spacing: 5) {
                        Text("Date")
                            .bold()
                        DatePicker("Date", selection: $date, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                            .padding(.bottom, 10)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Customers")
                        .font(.headline)
                        .padding(.bottom, 5)

                    TextField("Search Customers", text: $searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.bottom, 10)

                    ForEach(filteredCustomers, id: \.self) { customer in
                        CustomerSelectionRow(customer: customer, isSelected: selectedCustomers.contains(customer)) {
                            if selectedCustomers.contains(customer) {
                                selectedCustomers.remove(customer)
                            } else {
                                selectedCustomers.insert(customer)
                            }
                        }
                        .padding(.vertical, 5)
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)

                Button(action: {
                    route.identifier = identifier
                    route.date = date
                    route.customers = NSSet(set: selectedCustomers)
                    saveContext()
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
        .navigationBarTitle("Edit Route", displayMode: .inline)
    }

    private var filteredCustomers: [Customer] {
        if searchText.isEmpty {
            return Array(customers)
        } else {
            return customers.filter { $0.name?.localizedCaseInsensitiveContains(searchText) == true }
        }
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
        let context = PersistenceController.preview.container.viewContext
        let route = Route(context: context)
        route.identifier = "Test Route"
        route.date = Date()
        return EditRouteView(route: route).environment(\.managedObjectContext, context)
    }
}
