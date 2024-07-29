import SwiftUI
import CoreData

struct CustomerDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var customer: Customer
    @ObservedObject var route: Route
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
                    loadExistingQuantities()  // Reload quantities after saving
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
        let fetchRequest: NSFetchRequest<DailyDelivery> = DailyDelivery.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "customer == %@ AND route == %@", customer, route)

        do {
            let dailyDeliveries = try viewContext.fetch(fetchRequest)
            for delivery in dailyDeliveries {
                if let bottleType = delivery.bottleType {
                    deliveredQuantities[bottleType] = delivery.deliveredQuantity
                    returnedQuantities[bottleType] = delivery.returnedQuantity
                }
            }
        } catch {
            print("Failed to fetch daily deliveries: \(error)")
        }
    }

    private func saveQuantities() {
        let fetchRequest: NSFetchRequest<DailyDelivery> = DailyDelivery.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "customer == %@ AND route == %@", customer, route)

        do {
            let dailyDeliveries = try viewContext.fetch(fetchRequest)

            for delivery in dailyDeliveries {
                if let bottleType = delivery.bottleType {
                    delivery.deliveredQuantity = deliveredQuantities[bottleType] ?? 0
                    delivery.returnedQuantity = returnedQuantities[bottleType] ?? 0
                }
            }

            // Ensure new DailyDelivery objects are created if they don't already exist
            for (bottleType, quantity) in deliveredQuantities {
                if !dailyDeliveries.contains(where: { $0.bottleType == bottleType }) {
                    let newDelivery = DailyDelivery(context: viewContext)
                    newDelivery.bottleType = bottleType
                    newDelivery.waterType = (customer.defaultDeliveries as? Set<DefaultDelivery>)?.first(where: { $0.bottleType == bottleType })?.waterType ?? ""
                    newDelivery.deliveredQuantity = quantity
                    newDelivery.returnedQuantity = returnedQuantities[bottleType] ?? 0
                    newDelivery.customer = customer
                    newDelivery.route = route
                }
            }

            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
