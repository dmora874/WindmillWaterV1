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
    @State private var selectedCustomers: Set<Customer> = []
    @State private var searchText: String = ""

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
                    addRoute()
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
        .navigationBarTitle("Add Route", displayMode: .inline)
    }

    private var filteredCustomers: [Customer] {
        if searchText.isEmpty {
            return Array(customers)
        } else {
            return customers.filter { $0.name?.localizedCaseInsensitiveContains(searchText) == true }
        }
    }

    private func addRoute() {
        let newRoute = Route(context: viewContext)
        newRoute.identifier = identifier
        newRoute.date = date
        newRoute.customers = NSSet(set: selectedCustomers)

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
