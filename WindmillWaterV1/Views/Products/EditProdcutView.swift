import SwiftUI

struct EditProductView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var productName: String
    @State private var productPrice: String
    @State private var showAlert = false

    var product: Product

    init(product: Product) {
        self.product = product
        _productName = State(initialValue: product.name ?? "")
        _productPrice = State(initialValue: product.price ?? "")
    }

    var body: some View {
        Form {
            Section(header: Text("Product Details")) {
                TextField("Product Name", text: $productName)
                TextField("Product Price", text: $productPrice)
            }

            Button("Save Changes") {
                saveChanges()
            }
            .disabled(!hasChanges())
        }
        .navigationTitle("Edit Product")
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Success"), message: Text("Product details saved successfully"), dismissButton: .default(Text("OK")))
        }
    }

    private func saveChanges() {
        product.name = productName
        product.price = productPrice

        do {
            try viewContext.save()
            showAlert = true
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func hasChanges() -> Bool {
        return product.name != productName || product.price != productPrice
    }
}

struct EditProductView_Previews: PreviewProvider {
    static var previews: some View {
        EditProductView(product: Product())
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
