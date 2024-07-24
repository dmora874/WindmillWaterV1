import SwiftUI

struct AddCustomerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var address: String = ""
    @State private var phoneNumber: String = ""
    @State private var notes: String = ""
    @State private var pricingInformation: String = ""
    @State private var paymentMethod: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Customer Details")) {
                    TextField("Name", text: $name)
                    TextField("Address", text: $address)
                    TextField("Phone Number", text: $phoneNumber)
                    TextField("Notes", text: $notes)
                    TextField("Pricing Information", text: $pricingInformation)
                    TextField("Payment Method", text: $paymentMethod)
                }
                Button("Save") {
                    addCustomer()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
            .navigationBarTitle("Add Customer")
        }
    }

    private func addCustomer() {
        let newCustomer = Customer(context: viewContext)
        newCustomer.name = name
        newCustomer.address = address
        newCustomer.phoneNumber = phoneNumber
        newCustomer.notes = notes
        newCustomer.pricingInformation = pricingInformation
        newCustomer.paymentMethod = paymentMethod

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
        AddCustomerView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
