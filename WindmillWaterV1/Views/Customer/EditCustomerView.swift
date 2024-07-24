import SwiftUI

struct EditCustomerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var customer: Customer

    @State private var name: String
    @State private var address: String
    @State private var phoneNumber: String
    @State private var notes: String
    @State private var pricingInformation: String
    @State private var paymentMethod: String

    init(customer: Customer) {
        self.customer = customer
        _name = State(initialValue: customer.name ?? "")
        _address = State(initialValue: customer.address ?? "")
        _phoneNumber = State(initialValue: customer.phoneNumber ?? "")
        _notes = State(initialValue: customer.notes ?? "")
        _pricingInformation = State(initialValue: customer.pricingInformation ?? "")
        _paymentMethod = State(initialValue: customer.paymentMethod ?? "")
    }

    var body: some View {
        Form {
            Section(header: Text("Customer Details")) {
                VStack(alignment: .leading) {
                    Text("Name")
                    TextField("Name", text: $name)
                }
                VStack(alignment: .leading) {
                    Text("Address")
                    TextField("Address", text: $address)
                }
                VStack(alignment: .leading) {
                    Text("Phone Number")
                    TextField("Phone Number", text: $phoneNumber)
                }
                VStack(alignment: .leading) {
                    Text("Notes")
                    TextField("Notes", text: $notes)
                }
                VStack(alignment: .leading) {
                    Text("Pricing Information")
                    TextField("Pricing Information", text: $pricingInformation)
                }
                VStack(alignment: .leading) {
                    Text("Payment Method")
                    TextField("Payment Method", text: $paymentMethod)
                }
            }

            Button("Save") {
                saveCustomer()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .navigationBarTitle("Edit Customer")
    }

    private func saveCustomer() {
        customer.name = name
        customer.address = address
        customer.phoneNumber = phoneNumber
        customer.notes = notes
        customer.pricingInformation = pricingInformation
        customer.paymentMethod = paymentMethod

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct EditCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        EditCustomerView(customer: Customer()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
