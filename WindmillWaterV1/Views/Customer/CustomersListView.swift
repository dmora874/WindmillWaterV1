import SwiftUI
import CoreData

struct CustomersListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Customer.name, ascending: true)],
        animation: .default)
    private var customers: FetchedResults<Customer>
    
    @State private var showAddCustomerView = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(customers) { customer in
                    NavigationLink(destination: EditCustomerView(customer: customer)) {
                        VStack(alignment: .leading) {
                            Text("Name: \(customer.name ?? "Unknown")")
                            Text("Address: \(customer.address ?? "Unknown")")
                            Text("Phone: \(customer.phoneNumber ?? "Unknown")")
                            Text("Notes: \(customer.notes ?? "None")")
                            Text("Pricing: \(customer.pricingInformation ?? "Unknown")")
                            Text("Payment: \(customer.paymentMethod ?? "Unknown")")
                        }
                    }
                }
                .onDelete(perform: deleteCustomers)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: { showAddCustomerView.toggle() }) {
                        Label("Add Customer", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddCustomerView) {
                AddCustomerView().environment(\.managedObjectContext, viewContext)
            }
            .navigationTitle("Customers")
        }
    }

    private func deleteCustomers(offsets: IndexSet) {
        withAnimation {
            offsets.map { customers[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct CustomersListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomersListView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
