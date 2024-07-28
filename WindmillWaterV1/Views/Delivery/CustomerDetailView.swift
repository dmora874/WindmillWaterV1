import SwiftUI

struct CustomerDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var customer: Customer
    @Environment(\.presentationMode) var presentationMode

    @State private var deliveredQuantities: [String: Int16] = [:]
    @State private var returnedQuantities: [String: Int16] = [:]

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Section(header: Text("Customer Details").font(.headline)) {
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Name: \(customer.name ?? "")")
                        Text("Address: \(customer.address ?? "")")
                        Text("Phone Number: \(customer.phoneNumber ?? "")")
                        Text("Notes: \(customer.notes ?? "")")
                        Text("Pricing Information: \(customer.pricingInformation ?? "")")
                        Text("Payment Method: \(customer.paymentMethod ?? "")")
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                }

                Section(header: Text("Default Deliveries").font(.headline)) {
                    VStack(spacing: 10) {
                        ForEach((customer.defaultDeliveries as? Set<DefaultDelivery> ?? []).sorted { $0.bottleType ?? "" < $1.bottleType ?? "" }) { delivery in
                            HStack {
                                Text("Bottle Type: \(delivery.bottleType ?? "")")
                                Spacer()
                                Text("Water Type: \(delivery.waterType ?? "")")
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }

                Section(header: Text("Delivered Quantities").font(.headline)) {
                    VStack(spacing: 10) {
                        ForEach((customer.defaultDeliveries as? Set<DefaultDelivery> ?? []).sorted { $0.bottleType ?? "" < $1.bottleType ?? "" }) { delivery in
                            StepperWithLabel(label: "\(delivery.bottleType ?? "") \(delivery.waterType ?? "")", value: Binding(
                                get: { self.deliveredQuantities[delivery.bottleType ?? ""] ?? 0 },
                                set: { self.deliveredQuantities[delivery.bottleType ?? ""] = $0 }
                            ))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }

                Section(header: Text("Returned Quantities").font(.headline)) {
                    VStack(spacing: 10) {
                        ForEach((customer.defaultDeliveries as? Set<DefaultDelivery> ?? []).sorted { $0.bottleType ?? "" < $1.bottleType ?? "" }) { delivery in
                            StepperWithLabel(label: "\(delivery.bottleType ?? "")", value: Binding(
                                get: { self.returnedQuantities[delivery.bottleType ?? ""] ?? 0 },
                                set: { self.returnedQuantities[delivery.bottleType ?? ""] = $0 }
                            ))
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                }

                Button("Save") {
                    saveQuantities()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(PrimaryButtonStyle())
                .padding()
            }
            .padding()
        }
        .navigationBarTitle("Customer Delivery", displayMode: .inline)
        .onAppear {
            loadExistingQuantities()
        }
    }

    private func loadExistingQuantities() {
        // Load any existing delivered and returned quantities from Core Data if necessary
        // This code will be implementation specific depending on your data model
    }

    private func saveQuantities() {
        // Save delivered and returned quantities to Core Data
        // This code will be implementation specific depending on your data model
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
