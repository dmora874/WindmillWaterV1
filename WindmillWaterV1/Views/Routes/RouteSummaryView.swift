import SwiftUI

struct RouteSummaryView: View {
    @ObservedObject var route: Route
    
    private var deliverySummary: String {
        let deliveries = route.deliveries as? Set<Delivery> ?? []
        var summary: [String: Int] = [:]
        
        for delivery in deliveries {
            for product in delivery.products as? Set<Product> ?? [] {
                summary[product.name ?? "Unknown", default: 0] += Int(delivery.quantityDelivered)
            }
        }
        
        return summary.map { "\($0.key): \($0.value)" }.joined(separator: "\n")
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Route Identifier: \(route.identifier ?? "Unknown")")
            Text("Route Date: \(route.date ?? Date(), formatter: itemFormatter)")
            Text("Deliveries Summary:")
            Text(deliverySummary)
        }
        .padding()
        .navigationTitle("Route Summary")
    }
}

struct RouteSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let sampleRoute = Route(context: context)
        sampleRoute.identifier = "Sample Route"
        sampleRoute.date = Date()
        
        return RouteSummaryView(route: sampleRoute)
    }
}
