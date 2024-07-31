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
        ScrollView {
            VStack(spacing: 20) {
                Section(header: Text("Customer Details").font(.headline).foregroundColor(.gray)) {
                    TextField("Name", text: $name)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    TextField("Address", text: $address)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    TextField("Phone Number", text: $phoneNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    TextField("Notes", text: $notes)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    TextField("Pricing Information", text: $pricingInformation)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                    TextField("Payment Method", text: $paymentMethod)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 5)
                }

                Section(header: Text("Default Deliveries").font(.headline).foregroundColor(.gray)) {
                    ForEach(defaultDeliveries.indices, id: \.self) { index in
                        HStack {
                            Picker("Bottle Type", selection: $defaultDeliveries[index].bottleType) {
                                Text("5G").tag("5G")
                                Text("3G").tag("3G")
                                Text("Hg").tag("Hg")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)

                            Picker("Water Type", selection: $defaultDeliveries[index].waterType) {
                                Text("Regular").tag("Regular")
                                Text("Taos").tag("Taos")
                                Text("Distilled").tag("Distilled")
                            }
                            .pickerStyle(MenuPickerStyle())
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 5)

                            if index == defaultDeliveries.count - 1 {
                                Button(action: {
                                    defaultDeliveries.append(DeliveryDetail())
                                }) {
                                    Image(systemName: "plus")
                                        .foregroundColor(.blue)
                                }
                            } else {
                                Button(action: {
                                    defaultDeliveries.remove(at: index)
                                }) {
                                    Image(systemName: "minus")
                                        .foregroundColor(.red)
                                }
                            }
                        }
                    }
                }

                Button(action: {
                    saveCustomer()
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
        .navigationBarTitle("Edit Customer", displayMode: .inline)
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

struct EditCustomerView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let customer = Customer(context: context)
        customer.name = "John Doe"
        customer.address = "123 Main St"
        customer.phoneNumber = "555-555-5555"
        customer.notes = "Regular delivery"
        customer.pricingInformation = "$10 per bottle"
        customer.paymentMethod = "Credit Card"
        return EditCustomerView(customer: customer).environment(\.managedObjectContext, context)
    }
}
