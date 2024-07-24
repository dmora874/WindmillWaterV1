import SwiftUI

struct ManageDeliveriesView: View {
    @ObservedObject var route: Route
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Delivery.date, ascending: true)],
        animation: .default)
    private var deliveries: FetchedResults<Delivery>

    var body: some View {
        List {
            ForEach(deliveries.filter { $0.route == route }) { delivery in
                VStack(alignment: .leading) {
                    Text("Customer: \(delivery.customer?.name ?? "Unknown")")
                    Text("Delivered: \(delivery.quantityDelivered)")
                    Text("Returned: \(delivery.quantityReturned)")
                    Text("Notes: \(delivery.notes ?? "")")
                    NavigationLink(destination: EditDeliveryView(delivery: delivery)) {
                        Text("Edit Delivery")
                    }
                }
            }
        }
        .navigationBarTitle("Manage Deliveries")
    }
}

struct ManageDeliveriesView_Previews: PreviewProvider {
    static var previews: some View {
        ManageDeliveriesView(route: Route()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
