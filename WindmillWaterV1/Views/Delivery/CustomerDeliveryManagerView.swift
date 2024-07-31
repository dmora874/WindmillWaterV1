import SwiftUI
import CoreData

struct CustomerDeliveryManagerView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var customer: Customer
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
                HStack {
                    Text("Bottle Type: \(delivery.bottleType ?? "")")
                    Spacer()
                    Stepper(value: Binding(get: {
                        quantities.wrappedValue[delivery.bottleType ?? ""] ?? 0
                    }, set: {
                        quantities.wrappedValue[delivery.bottleType ?? ""] = $0
                    }), in: 0...Int16.max) {
                        Text("\(quantities.wrappedValue[delivery.bottleType ?? ""] ?? 0)")
                    }
                }
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
        fetchRequest.predicate = NSPredicate(format: "customer == %@", customer)

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
        fetchRequest.predicate = NSPredicate(format: "customer == %@", customer)

        do {
            let dailyDeliveries = try viewContext.fetch(fetchRequest)

            for delivery in dailyDeliveries {
                if let bottleType = delivery.bottleType {
                    delivery.deliveredQuantity = deliveredQuantities[bottleType] ?? 0
                    delivery.returnedQuantity = returnedQuantities[bottleType] ?? 0
                }
            }

            for (bottleType, quantity) in deliveredQuantities {
                if !dailyDeliveries.contains(where: { $0.bottleType == bottleType }) {
                    let newDelivery = DailyDelivery(context: viewContext)
                    newDelivery.bottleType = bottleType
                    newDelivery.deliveredQuantity = quantity
                    newDelivery.returnedQuantity = returnedQuantities[bottleType] ?? 0
                    newDelivery.customer = customer
                }
            }

            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
