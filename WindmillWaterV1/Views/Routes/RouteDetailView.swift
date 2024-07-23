import SwiftUI

struct RouteDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var route: Route

    var body: some View {
        VStack {
            List {
                ForEach(route.deliveriesArray, id: \.self) { delivery in
                    NavigationLink(destination: EditDeliveryView(delivery: delivery)) {
                        Text("\(delivery.date ?? Date(), formatter: itemFormatter)")
                    }
                }
                .onDelete(perform: deleteDeliveries)
            }
            .navigationBarTitle(Text(route.identifier ?? "Unknown Route"), displayMode: .inline)
            .navigationBarItems(trailing: EditButton())
        }
    }
    
    private func deleteDeliveries(offsets: IndexSet) {
        withAnimation {
            offsets.map { route.deliveriesArray[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                // Handle the error appropriately
            }
        }
    }
}

struct RouteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        let sampleRoute = Route(context: context)
        sampleRoute.identifier = "Sample Route"
        sampleRoute.date = Date()
        
        return RouteDetailView(route: sampleRoute).environment(\.managedObjectContext, context)
    }
}
