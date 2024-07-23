import SwiftUI

struct DeliveryDetailView: View {
    @ObservedObject var delivery: Delivery

    var body: some View {
        VStack {
            Text("Delivery Details")
                .font(.largeTitle)
                .padding()

            Text("Date: \(delivery.date ?? Date(), formatter: dateFormatter)")
            Text("Quantity Delivered: \(delivery.quantityDelivered)")
            Text("Quantity Returned: \(delivery.quantityReturned)")
            Text("Notes: \(delivery.notes ?? "No notes")")

            List {
                ForEach(delivery.products?.allObjects as? [Product] ?? []) { product in
                    Text(product.name ?? "Unknown product")
                }
            }
        }
        .navigationBarTitle("Delivery Detail", displayMode: .inline)
    }

    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
}

struct DeliveryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let sampleDelivery = Delivery(context: context)
        sampleDelivery.date = Date()
        sampleDelivery.quantityDelivered = 10
        sampleDelivery.quantityReturned = 2
        sampleDelivery.notes = "Sample notes"
        
        return DeliveryDetailView(delivery: sampleDelivery)
            .environment(\.managedObjectContext, context)
    }
}
