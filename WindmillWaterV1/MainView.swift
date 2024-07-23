import SwiftUI

struct MainView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: CustomerListView()) {
                    Text("View Customers")
                }
                NavigationLink(destination: RoutesView()) {
                    Text("View Routes")
                }
                NavigationLink(destination: ManageProductsView()) {
                    Text("View Products")
                }
                Button(action: exportCustomers) {
                    Text("Export Customers")
                }
            }
            .navigationTitle("Windmill Water Delivery")
        }
    }

    private func exportCustomers() {
        let context = PersistenceController.shared.container.viewContext
        let csvData = ExportData.exportCustomers(context: context)
        let fileName = "Customers.csv"
        let path = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(fileName)
        
        do {
            try csvData.write(to: path, atomically: true, encoding: String.Encoding.utf8)
            print("Exported CSV to: \(path)")
        } catch {
            print("Failed to write CSV: \(error)")
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
