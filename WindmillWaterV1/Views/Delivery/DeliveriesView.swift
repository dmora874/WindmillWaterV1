import SwiftUI

struct DeliveriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Delivery.date, ascending: true)],
        animation: .default)
    private var deliveries: FetchedResults<Delivery>

    var body: some View {
        NavigationView {
            List {
                ForEach(deliveries) { delivery in
                    NavigationLink(destination: DeliveryDetailView(delivery: delivery)) {
                        VStack(alignment: .leading) {
                            Text("Customer: \(delivery.customer?.name ?? "Unknown")")
                            Text("Route Date: \(delivery.route?.date ?? Date(), formatter: itemFormatter)")
                        }
                    }
                }
                .onDelete(perform: deleteDeliveries)
            }
            .navigationTitle("Deliveries")
            .navigationBarItems(trailing: Button("Add Delivery") {
                addDelivery()
            })
        }
    }

    private func addDelivery() {
        let newDelivery = Delivery(context: viewContext)
        newDelivery.date = Date()
        newDelivery.customer = deliveries.first?.customer // Assign a customer to the new delivery
        newDelivery.route = deliveries.first?.route // Assign a route to the new delivery
        do {
            try viewContext.save()
        } catch {
            // Handle error appropriately
            print("Error adding delivery: \(error)")
        }
    }

    private func deleteDeliveries(offsets: IndexSet) {
        withAnimation {
            offsets.map { deliveries[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Handle error appropriately
                print("Error deleting delivery: \(error)")
            }
        }
    }
}
