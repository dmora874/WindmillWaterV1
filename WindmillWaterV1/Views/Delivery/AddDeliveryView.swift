import SwiftUI

struct AddDeliveryView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode

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
        .navigationBarTitle("Add Delivery")
        .navigationBarItems(trailing: Button("Save") {
            addDelivery()
        })
    }

    private func addDelivery() {
        let newDelivery = Delivery(context: viewContext)
        newDelivery.products = NSSet(set: selectedProducts)
        newDelivery.quantityDelivered = Int16(quantityDelivered) ?? 0
        newDelivery.quantityReturned = Int16(quantityReturned) ?? 0
        newDelivery.notes = notes
        newDelivery.date = date

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            print("Error saving delivery: \(error)")
        }
    }
}

struct AddDeliveryView_Previews: PreviewProvider {
    static var previews: some View {
        AddDeliveryView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
