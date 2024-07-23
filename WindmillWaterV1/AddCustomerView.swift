import SwiftUI

struct AddCustomerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var address = ""
    @State private var phoneNumber = ""
    @State private var notes = ""
    @State private var paymentMethod = ""
    @State private var pricingInformation = ""

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

            Button("Save Customer") {
                addCustomer()
            }
        }
        .navigationTitle("Add Customer")
    }

    private func addCustomer() {
        let newCustomer = Customer(context: viewContext)
        newCustomer.name = name
        newCustomer.address = address
        newCustomer.phoneNumber = phoneNumber
        newCustomer.notes = notes
        newCustomer.paymentMethod = paymentMethod
        newCustomer.pricingInformation = pricingInformation

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        AddCustomerView()
    }
}
