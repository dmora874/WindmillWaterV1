import SwiftUI

struct EditCustomerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var name: String
    @State private var address: String
    @State private var phoneNumber: String
    @State private var notes: String
    @State private var paymentMethod: String
    @State private var pricingInformation: String
    @State private var showAlert = false

    var customer: Customer

    init(customer: Customer) {
        self.customer = customer
        _name = State(initialValue: customer.name ?? "")
        _address = State(initialValue: customer.address ?? "")
        _phoneNumber = State(initialValue: customer.phoneNumber ?? "")
        _notes = State(initialValue: customer.notes ?? "")
        _paymentMethod = State(initialValue: customer.paymentMethod ?? "")
        _pricingInformation = State(initialValue: customer.pricingInformation ?? "")
    }

    var body: some View {
        Form {
            Section(header: Text("Customer Details")) {
                TextField("Name", text: $name)
                TextField("Address", text: $address)
                TextField("Phone Number", text: $phoneNumber)
                TextField("Notes", text: $notes)
                TextField("Payment Method", text: $paymentMethod)
                TextField("Pricing Information", text: $pricingInformation)
            }

            Button("Save Changes") {
                saveChanges()
            }
        }
        .navigationTitle("Edit Customer")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("Customer details saved successfully"), dismissButton: .default(Text("OK")))
        }
    }

    private func saveChanges() {
        customer.name = name
        customer.address = address
        customer.phoneNumber = phoneNumber
        customer.notes = notes
        customer.paymentMethod = paymentMethod
        customer.pricingInformation = pricingInformation

        do {
            try viewContext.save()
            showAlert = true
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EditCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        EditCustomerView(customer: Customer())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
