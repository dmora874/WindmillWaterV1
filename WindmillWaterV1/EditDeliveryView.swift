import SwiftUI

struct EditDeliveryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var delivery: Delivery

    @FetchRequest(
        entity: Product.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)]
    ) var products: FetchedResults<Product>

    @State private var selectedProducts: Set<Product> = []
    @State private var quantityDelivered: String = ""
    @State private var quantityReturned: String = ""
    @State private var notes: String = ""
    @State private var date: Date = Date()

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Delivery Details")) {
                    DatePicker("Date", selection: $date, displayedComponents: .date)
                    TextField("Quantity Delivered", text: $quantityDelivered)
                        .keyboardType(.numberPad)
                    TextField("Quantity Returned", text: $quantityReturned)
                        .keyboardType(.numberPad)
                    TextField("Notes", text: $notes)
                }

                Section(header: Text("Products")) {
                    List(products, id: \.self) { product in
                        ProductSelectionRow(product: product, isSelected: selectedProducts.contains(product)) {
                            if selectedProducts.contains(product) {
                                selectedProducts.remove(product)
                            } else {
                                selectedProducts.insert(product)
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("Edit Delivery")
            .navigationBarItems(trailing: Button("Save") {
                updateDelivery()
            })
            .onAppear {
                if let products = delivery.products as? Set<Product> {
                    selectedProducts = products
                }
                quantityDelivered = String(delivery.quantityDelivered)
                quantityReturned = String(delivery.quantityReturned)
                notes = delivery.notes ?? ""
                date = delivery.date ?? Date()
            }
        }
    }

    private func updateDelivery() {
        delivery.products = NSSet(set: selectedProducts)
        delivery.quantityDelivered = Int16(quantityDelivered) ?? 0
        delivery.quantityReturned = Int16(quantityReturned) ?? 0
        delivery.notes = notes
        delivery.date = date

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            // Handle the error appropriately
            print("Error saving delivery: \(error)")
        }
    }
}

struct EditDeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        EditDeliveryView(delivery: Delivery()).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
