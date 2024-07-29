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
                ForEach(route.customersList, id: \.self) { customer in
                    VStack(alignment: .leading) {
                        Text("Customer: \(customer.name ?? "Unknown")")
                            .font(.headline)

                        let deliveries = customer.dailyDeliveriesList.filter { $0.route == route && Calendar.current.isDateInToday($0.date ?? Date()) }

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
}

extension Customer {
    var dailyDeliveriesList: [DailyDelivery] {
        let set = dailyDeliveries as? Set<DailyDelivery> ?? []
        return Array(set)
    }
}
