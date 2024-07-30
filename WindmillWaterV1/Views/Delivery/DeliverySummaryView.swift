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

            VStack(alignment: .leading) {
                Text("TOTAL BOTTLES DELIVERED")
                    .font(.headline)
                    .padding(.top, 10)

                ForEach(totalBottles(by: \.deliveredQuantity).sorted(by: { $0.key < $1.key }), id: \.key) { bottleType, total in
                    Text("\(bottleType): \(total)")
                }
                
                Text("TOTAL BOTTLES RETURNED")
                    .font(.headline)
                    .padding(.top, 10)

                ForEach(totalBottles(by: \.returnedQuantity).sorted(by: { $0.key < $1.key }), id: \.key) { bottleType, total in
                    Text("\(bottleType): \(total)")
                }
            }
            .padding()

            List {
                ForEach(route.customersArray, id: \.self) { customer in
                    VStack(alignment: .leading) {
                        Text("Customer: \(customer.name ?? "Unknown")")
                            .font(.headline)

                        let deliveries = customer.dailyDeliveriesList.filter { $0.route == route }

                        ForEach(deliveries.groupedBy(\.bottleType).sorted(by: { $0.key ?? "" < $1.key ?? "" }), id: \.key) { bottleType, group in
                            VStack(alignment: .leading) {
                                if let type = bottleType {
                                    Text("\(type) Delivered: \(group.reduce(0) { $0 + $1.deliveredQuantity })")
                                    Text("\(type) Returned: \(group.reduce(0) { $0 + $1.returnedQuantity })")
                                }
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
