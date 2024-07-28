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
    @State private var defaultDeliveries: [DeliveryDetail] = []

    init(customer: Customer) {
        self.customer = customer
        _name = State(initialValue: customer.name ?? "")
        _address = State(initialValue: customer.address ?? "")
        _phoneNumber = State(initialValue: customer.phoneNumber ?? "")
        _notes = State(initialValue: customer.notes ?? "")
        _pricingInformation = State(initialValue: customer.pricingInformation ?? "")
        _paymentMethod = State(initialValue: customer.paymentMethod ?? "")
        
        if let deliveries = customer.defaultDeliveries?.allObjects as? [DefaultDelivery] {
            _defaultDeliveries = State(initialValue: deliveries.map { DeliveryDetail(bottleType: $0.bottleType ?? "5G", waterType: $0.waterType ?? "Regular") })
        }
    }

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

        for delivery in customer.defaultDeliveries?.allObjects as? [DefaultDelivery] ?? [] {
            viewContext.delete(delivery)
        }

        for deliveryDetail in defaultDeliveries {
            let newDelivery = DefaultDelivery(context: viewContext)
            newDelivery.bottleType = deliveryDetail.bottleType
            newDelivery.waterType = deliveryDetail.waterType
            newDelivery.customer = customer
        }

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
