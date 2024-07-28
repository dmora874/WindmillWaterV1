import SwiftUI

struct CustomerDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var customer: Customer
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Form {
            Section(header: Text("Customer Details")) {
                Text("Name: \(customer.name ?? "")")
                Text("Address: \(customer.address ?? "")")
                Text("Phone Number: \(customer.phoneNumber ?? "")")
                Text("Notes: \(customer.notes ?? "")")
                Text("Pricing Information: \(customer.pricingInformation ?? "")")
                Text("Payment Method: \(customer.paymentMethod ?? "")")
            }

            Section(header: Text("Default Deliveries")) {
                ForEach((customer.defaultDeliveries as? Set<DefaultDelivery> ?? []).sorted { $0.bottleType ?? "" < $1.bottleType ?? "" }) { delivery in
                    HStack {
                        Text("Bottle Type: \(delivery.bottleType ?? "")")
                        Spacer()
                        Text("Water Type: \(delivery.waterType ?? "")")
                    }
                }
            }

            Button("Back") {
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .navigationBarTitle("Customer Details", displayMode: .inline)
    }
}
