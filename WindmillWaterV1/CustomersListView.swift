import SwiftUI

struct CustomerListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Customer.name, ascending: true)],
        animation: .default)
    private var customers: FetchedResults<Customer>

    var body: some View {
        NavigationView {
            List {
                ForEach(customers) { customer in
                    NavigationLink(destination: EditCustomerView(customer: customer)) {
                        VStack(alignment: .leading) {
                            Text(customer.name ?? "Unknown Name")
                                .font(.headline)
                            Text(customer.address ?? "Unknown Address")
                                .font(.subheadline)
                        }
                    }
                }
                .onDelete(perform: deleteCustomers)
            }
            .navigationTitle("Customers")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    NavigationLink(destination: AddCustomerView()) {
                        Label("Add Customer", systemImage: "plus")
                    }
                }
            }
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

struct CustomerListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerListView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
