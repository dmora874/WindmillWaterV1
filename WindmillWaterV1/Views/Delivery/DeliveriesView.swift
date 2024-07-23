import SwiftUI

struct DeliveriesView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Delivery.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Delivery.date, ascending: true)]
    ) var deliveries: FetchedResults<Delivery>
    
    var body: some View {
        NavigationView {
            List {
                ForEach(deliveries) { delivery in
                    NavigationLink(destination: DeliveryDetailView(delivery: delivery)) {
                        Text("Delivery on \(delivery.date ?? Date(), formatter: dateFormatter)")
                    }
                }
                .onDelete(perform: deleteDeliveries)
            }
            .navigationBarTitle("Deliveries")
            .navigationBarItems(trailing: NavigationLink("Add Delivery", destination: AddDeliveryView()))
        }
    }
    
    private func deleteDeliveries(offsets: IndexSet) {
        for index in offsets {
            let delivery = deliveries[index]
            viewContext.delete(delivery)
        }
        do {
            try viewContext.save()
        } catch {
            print("Error deleting delivery: \(error)")
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

struct DeliveriesView_Previews: PreviewProvider {
    static var previews: some View {
        DeliveriesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
