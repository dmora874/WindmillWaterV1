import SwiftUI
import CoreData

struct DeliverySummaryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var route: Route

    var body: some View {
        VStack(alignment: .leading) {
            Text("Delivery Summary")
                .font(.largeTitle)
                .padding()

            List {
                let customers = route.customersArray

                let deliveriesByBottleType = Dictionary(grouping: customers.flatMap { $0.dailyDeliveriesList.filter { $0.route == route } }) { $0.bottleType }

                Section(header: Text("Total Bottles Delivered:")) {
                    ForEach(deliveriesByBottleType.keys.sorted(by: { ($0 ?? "") < ($1 ?? "") }), id: \.self) { bottleType in
                        let totalDelivered = deliveriesByBottleType[bottleType]?.reduce(0) { $0 + ($1.deliveredQuantity ?? 0) } ?? 0
                        Text("\(bottleType ?? "") Delivered: \(totalDelivered)")
                    }
                }

                Section(header: Text("Total Bottles Returned:")) {
                    ForEach(deliveriesByBottleType.keys.sorted(by: { ($0 ?? "") < ($1 ?? "") }), id: \.self) { bottleType in
                        let totalReturned = deliveriesByBottleType[bottleType]?.reduce(0) { $0 + ($1.returnedQuantity ?? 0) } ?? 0
                        Text("\(bottleType ?? "") Returned: \(totalReturned)")
                    }
                }

                ForEach(customers, id: \.self) { customer in
                    VStack(alignment: .leading) {
                        Text("Customer: \(customer.name ?? "Unknown")")
                            .font(.headline)

                        let deliveries = customer.dailyDeliveriesList.filter { $0.route == route }

                        ForEach(deliveries, id: \.self) { delivery in
                            VStack(alignment: .leading) {
                                Text("\(delivery.bottleType ?? "") \(delivery.waterType ?? "") Delivered: \(delivery.deliveredQuantity)")
                                Text("\(delivery.bottleType ?? "") Returned: \(delivery.returnedQuantity)")
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.bottom, 5)
                }
            }
        }
        .padding()
        .navigationBarTitle("Delivery Summary", displayMode: .inline)
    }

    private func totalBottles(by keyPath: KeyPath<DailyDelivery, Int16>) -> [String: Int16] {
        var totals: [String: Int16] = [:]
        
        for customer in route.customersArray {
            for delivery in customer.dailyDeliveriesList.filter({ $0.route == route }) {
                if let bottleType = delivery.bottleType {
                    totals[bottleType, default: 0] += delivery[keyPath: keyPath]
                }
            }
        }
        
        return totals
    }
}

extension Sequence {
    func groupedBy<Key: Hashable>(_ keyPath: KeyPath<Element, Key>) -> [Key: [Element]] {
        Dictionary(grouping: self, by: { $0[keyPath: keyPath] })
    }
}
