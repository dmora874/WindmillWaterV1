import SwiftUI

struct AddCustomerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var name = ""
    @State private var address = ""
    @State private var phoneNumber = ""
    @State private var notes = ""
    @State private var pricingInformation = ""
    @State private var paymentMethod = ""
    @State private var defaultDeliveries: [DeliveryDetail] = [DeliveryDetail()]

    var body: some View {
        Form {
            Section(header: Text("Customer Details")) {
                TextField("Name", text: $name)
                TextField("Address", text: $address)
                TextField("Phone Number", text: $phoneNumber)
                TextField("Notes", text: $notes)
                TextField("Pricing Information", text: $pricingInformation)
                TextField("Payment Method", text: $paymentMethod)
            }

            Section(header: Text("Default Deliveries")) {
                ForEach(defaultDeliveries.indices, id: \.self) { index in
                    HStack {
                        Picker("Bottle Type", selection: $defaultDeliveries[index].bottleType) {
                            Text("5G").tag("5G")
                            Text("3G").tag("3G")
                            Text("Hg").tag("Hg")
                        }
                        .pickerStyle(MenuPickerStyle())

                        Picker("Water Type", selection: $defaultDeliveries[index].waterType) {
                            Text("Regular").tag("Regular")
                            Text("Taos").tag("Taos")
                            Text("Distilled").tag("Distilled")
                        }
                        .pickerStyle(MenuPickerStyle())

                        if index == defaultDeliveries.count - 1 {
                            Button(action: {
                                defaultDeliveries.append(DeliveryDetail())
                            }) {
                                Image(systemName: "plus")
                            }
                        } else {
                            Button(action: {
                                defaultDeliveries.remove(at: index)
                            }) {
                                Image(systemName: "minus")
                            }
                        }
                    }
                }
            }

            Button("Save") {
                addCustomer()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .navigationBarTitle("Add Customer")
    }

    private func addCustomer() {
        let newCustomer = Customer(context: viewContext)
        newCustomer.name = name
        newCustomer.address = address
        newCustomer.phoneNumber = phoneNumber
        newCustomer.notes = notes
        newCustomer.pricingInformation = pricingInformation
        newCustomer.paymentMethod = paymentMethod

        for deliveryDetail in defaultDeliveries {
            let newDelivery = DefaultDelivery(context: viewContext)
            newDelivery.bottleType = deliveryDetail.bottleType
            newDelivery.waterType = deliveryDetail.waterType
            newDelivery.customer = newCustomer
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct DeliveryDetail {
    var bottleType: String = "5G"
    var waterType: String = "Regular"
}
