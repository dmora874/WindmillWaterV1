import SwiftUI
import CoreData

struct DeliveriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Delivery.date, ascending: true)],
        animation: .default)
    private var deliveries: FetchedResults<Delivery>

    var body: some View {
        List {
            ForEach(deliveries) { delivery in
                VStack(alignment: .leading) {
                    Text("Date: \(delivery.date ?? Date(), formatter: dateFormatter)")
                    Text("Customer: \(delivery.customer?.name ?? "Unknown")")
                    Text("Route: \(delivery.route?.date ?? Date(), formatter: dateFormatter)")
                }
            }
        }
        .navigationTitle("Deliveries")
    }
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    return formatter
}()
