import SwiftUI

struct ManageProductsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var productName = ""
    @State private var productPrice = ""

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Product.name, ascending: true)],
        animation: .default)
    private var products: FetchedResults<Product>

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Add New Product")) {
                    TextField("Product Name", text: $productName)
                    TextField("Product Price", text: $productPrice)
                    Button("Add Product") {
                        addProduct()
                    }
                }
            }
            
            List {
                ForEach(products) { product in
                    NavigationLink(destination: EditProductView(product: product)) {
                        HStack {
                            Text(product.name ?? "Unknown")
                            Spacer()
                            Text(product.price ?? "Unknown")
                        }
                    }
                }
                .onDelete(perform: deleteProducts)
            }
        }
        .navigationTitle("Manage Products")
    }

    private func addProduct() {
        let newProduct = Product(context: viewContext)
        newProduct.name = productName
        newProduct.price = productPrice

        do {
            try viewContext.save()
            clearFields()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func clearFields() {
        productName = ""
        productPrice = ""
    }

    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ManageProductsView_Previews: PreviewProvider {
    static var previews: some View {
        ManageProductsView()
    }
}
