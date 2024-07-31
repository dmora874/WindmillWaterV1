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
                customerDetailsSection
                Divider().padding(.vertical, 10)
                defaultDeliveriesSection
                Divider().padding(.vertical, 10)
                quantitiesSection(title: "Delivered Quantities", quantities: $deliveredQuantities)
                Divider().padding(.vertical, 10)
                quantitiesSection(title: "Returned Quantities", quantities: $returnedQuantities)

                Button(action: {
                    saveQuantities()
                    loadExistingQuantities()  // Reload quantities after saving
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Save")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
            }
            .padding()
        }
        .navigationBarTitle("Customer Delivery", displayMode: .inline)
        .onAppear {
            loadExistingQuantities()
        }
    }

    private var customerDetailsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Customer Details")
                .font(.headline)
                .padding(.bottom, 5)

            detailRow(label: "Name", value: customer.name)
            detailRow(label: "Address", value: customer.address)
            detailRow(label: "Phone Number", value: customer.phoneNumber)
            detailRow(label: "Notes", value: customer.notes)
            detailRow(label: "Pricing Information", value: customer.pricingInformation)
            detailRow(label: "Payment Method", value: customer.paymentMethod)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }

    private var defaultDeliveriesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Default Deliveries")
                .font(.headline)
                .padding(.bottom, 5)

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

    private func quantitiesSection(title: String, quantities: Binding<[String: Int16]>) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)

            ForEach((customer.defaultDeliveries as? Set<DefaultDelivery> ?? []).sorted { $0.bottleType ?? "" < $1.bottleType ?? "" }) { delivery in
                StepperWithLabel(label: "\(delivery.bottleType ?? "") \(delivery.waterType ?? "")", value: Binding(
                    get: { quantities.wrappedValue[delivery.bottleType ?? ""] ?? 0 },
                    set: { quantities.wrappedValue[delivery.bottleType ?? ""] = $0 }
                ))
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
        }
    }

    private func detailRow(label: String, value: String?) -> some View {
        HStack {
            Text("\(label):")
                .bold()
            Spacer()
            Text(value ?? "")
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
