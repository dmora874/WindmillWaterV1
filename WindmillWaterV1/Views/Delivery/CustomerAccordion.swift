import SwiftUI

struct CustomerAccordion: View {
    @ObservedObject var customer: Customer
    @State private var isExpanded = false

    var body: some View {
        VStack {
            HStack {
                Text(customer.name ?? "Unknown Customer")
                Spacer()
                Button(action: {
                    isExpanded.toggle()
                }) {
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .foregroundColor(.blue)
                }
            }
            .padding()

            if isExpanded {
                VStack {
                    Section(header: Text("Delivered Quantities")) {
                        TextField("5G Reg", value: Binding(get: { Int(customer.quantityDelivered5GReg) }, set: { customer.quantityDelivered5GReg = Int16($0) }), formatter: NumberFormatter())
                        TextField("3G Reg", value: Binding(get: { Int(customer.quantityDelivered3GReg) }, set: { customer.quantityDelivered3GReg = Int16($0) }), formatter: NumberFormatter())
                        TextField("Hg Reg", value: Binding(get: { Int(customer.quantityDeliveredHgReg) }, set: { customer.quantityDeliveredHgReg = Int16($0) }), formatter: NumberFormatter())
                        TextField("5G Taos", value: Binding(get: { Int(customer.quantityDelivered5GTaos) }, set: { customer.quantityDelivered5GTaos = Int16($0) }), formatter: NumberFormatter())
                        TextField("3G Taos", value: Binding(get: { Int(customer.quantityDelivered3GTaos) }, set: { customer.quantityDelivered3GTaos = Int16($0) }), formatter: NumberFormatter())
                        TextField("Hg Taos", value: Binding(get: { Int(customer.quantityDeliveredHgTaos) }, set: { customer.quantityDeliveredHgTaos = Int16($0) }), formatter: NumberFormatter())
                        TextField("5G Dist", value: Binding(get: { Int(customer.quantityDelivered5GDist) }, set: { customer.quantityDelivered5GDist = Int16($0) }), formatter: NumberFormatter())
                        TextField("3G Dist", value: Binding(get: { Int(customer.quantityDelivered3GDist) }, set: { customer.quantityDelivered3GDist = Int16($0) }), formatter: NumberFormatter())
                        TextField("Hg Dist", value: Binding(get: { Int(customer.quantityDeliveredHgDist) }, set: { customer.quantityDeliveredHgDist = Int16($0) }), formatter: NumberFormatter())
                    }

                    Section(header: Text("Returned Quantities")) {
                        TextField("5G", value: Binding(get: { Int(customer.quantityReturned5G) }, set: { customer.quantityReturned5G = Int16($0) }), formatter: NumberFormatter())
                        TextField("3G", value: Binding(get: { Int(customer.quantityReturned3G) }, set: { customer.quantityReturned3G = Int16($0) }), formatter: NumberFormatter())
                        TextField("Hg", value: Binding(get: { Int(customer.quantityReturnedHg) }, set: { customer.quantityReturnedHg = Int16($0) }), formatter: NumberFormatter())
                    }

                    Section(header: Text("Notes")) {
                        TextField("Notes", text: Binding(get: { customer.notes ?? "" }, set: { customer.notes = $0 }))
                    }
                    
                    Button("Save") {
                        saveContext()
                    }
                }
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(10)
                .padding(.bottom, 5)
            }
        }
    }

    private func saveContext() {
        do {
            try customer.managedObjectContext?.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
