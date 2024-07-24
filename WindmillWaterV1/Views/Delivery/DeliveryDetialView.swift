import SwiftUI
import CoreData

struct DeliveryDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var delivery: Delivery

    @State private var quantitiesDelivered: [String: Int] = [:]
    @State private var quantitiesReturned: [String: Int] = [:]

    var body: some View {
        Form {
            Section(header: Text("Delivered Quantities")) {
                ForEach(deliveryTypes, id: \.self) { type in
                    HStack {
                        Text(type)
                        TextField("Quantity", value: Binding(
                            get: { quantitiesDelivered[type] ?? 0 },
                            set: { quantitiesDelivered[type] = $0 }
                        ), formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                }
            }
            
            Section(header: Text("Returned Quantities")) {
                ForEach(returnTypes, id: \.self) { type in
                    HStack {
                        Text(type)
                        TextField("Quantity", value: Binding(
                            get: { quantitiesReturned[type] ?? 0 },
                            set: { quantitiesReturned[type] = $0 }
                        ), formatter: NumberFormatter())
                            .keyboardType(.numberPad)
                    }
                }
            }

            Button("Save") {
                updateDelivery()
            }
        }
        .onAppear {
            loadQuantities()
        }
    }

    private var deliveryTypes: [String] {
        ["5G Reg", "3G Reg", "Hg Reg", "5G Taos", "3G Taos", "Hg Taos", "5G Dist", "3G Dist", "Hg Dist"]
    }

    private var returnTypes: [String] {
        ["5G", "3G", "Hg"]
    }

    private func loadQuantities() {
        quantitiesDelivered = [
            "5G Reg": Int(delivery.quantityDelivered5GReg),
            "3G Reg": Int(delivery.quantityDelivered3GReg),
            "Hg Reg": Int(delivery.quantityDeliveredHgReg),
            "5G Taos": Int(delivery.quantityDelivered5GTaos),
            "3G Taos": Int(delivery.quantityDelivered3GTaos),
            "Hg Taos": Int(delivery.quantityDeliveredHgTaos),
            "5G Dist": Int(delivery.quantityDelivered5GDist),
            "3G Dist": Int(delivery.quantityDelivered3GDist),
            "Hg Dist": Int(delivery.quantityDeliveredHgDist)
        ]

        quantitiesReturned = [
            "5G": Int(delivery.quantityReturned5G),
            "3G": Int(delivery.quantityReturned3G),
            "Hg": Int(delivery.quantityReturnedHg)
        ]
    }

    private func updateDelivery() {
        delivery.quantityDelivered5GReg = Int16(quantitiesDelivered["5G Reg"] ?? 0)
        delivery.quantityDelivered3GReg = Int16(quantitiesDelivered["3G Reg"] ?? 0)
        delivery.quantityDeliveredHgReg = Int16(quantitiesDelivered["Hg Reg"] ?? 0)
        delivery.quantityDelivered5GTaos = Int16(quantitiesDelivered["5G Taos"] ?? 0)
        delivery.quantityDelivered3GTaos = Int16(quantitiesDelivered["3G Taos"] ?? 0)
        delivery.quantityDeliveredHgTaos = Int16(quantitiesDelivered["Hg Taos"] ?? 0)
        delivery.quantityDelivered5GDist = Int16(quantitiesDelivered["5G Dist"] ?? 0)
        delivery.quantityDelivered3GDist = Int16(quantitiesDelivered["3G Dist"] ?? 0)
        delivery.quantityDeliveredHgDist = Int16(quantitiesDelivered["Hg Dist"] ?? 0)

        delivery.quantityReturned5G = Int16(quantitiesReturned["5G"] ?? 0)
        delivery.quantityReturned3G = Int16(quantitiesReturned["3G"] ?? 0)
        delivery.quantityReturnedHg = Int16(quantitiesReturned["Hg"] ?? 0)

        do {
            try viewContext.save()
        } catch {
            print("Error saving delivery: \(error)")
        }
    }
}

struct DeliveryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveryDetailView(delivery: Delivery())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
