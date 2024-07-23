import SwiftUI
import CoreData

struct DeliveryDetailView: View {
    var route: Route

    var body: some View {
        List {
            if let deliveries = route.deliveries as? Set<Delivery> {
                ForEach(Array(deliveries), id: \.self) { delivery in
                    VStack(alignment: .leading) {
                        Text("Customer: \(delivery.customer?.name ?? "Unknown")")
                        Text("Quantity Delivered: \(delivery.quantityDelivered)")
                        Text("Quantity Returned: \(delivery.quantityReturned)")
                        Text("Notes: \(delivery.notes ?? "")")
                    }
                }
            }
        }
        .navigationTitle("Deliveries for Route")
    }
}
