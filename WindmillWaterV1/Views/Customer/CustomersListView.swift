import SwiftUI

struct CustomersListView: View {
    @State private var customersData: [[String]] = []
    @State private var showAddCustomerView = false
    @State private var searchText: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Search Customers", text: $searchText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                
                List {
                    ForEach(filteredCustomers, id: \.self) { customer in
                        NavigationLink(destination: Text("Edit Customer View")) {
                            Text(customer[1])  // Displaying the customer's name
                                .font(.headline)
                                .padding(.vertical, 10)
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Customers")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: fetchGoogleSheetData) {
                            Text("Refresh")
                        }
                    }
                    ToolbarItem {
                        Button(action: { showAddCustomerView.toggle() }) {
                            Label("Add Customer", systemImage: "plus")
                        }
                    }
                }
                .sheet(isPresented: $showAddCustomerView) {
                    // Replace with your AddCustomerView or create a Google Sheets write function
                    Text("Add Customer View")
                }
                .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
                .onAppear(perform: fetchGoogleSheetData)
            }
        }
    }
    
    private var filteredCustomers: [[String]] {
        if searchText.isEmpty {
            return customersData
        } else {
            return customersData.filter { $0[1].localizedCaseInsensitiveContains(searchText) }  // Filtering by customer name
        }
    }

    private func fetchGoogleSheetData() {
        let googleSheetsService = GoogleSheetsService()
        googleSheetsService.fetchCustomerData { values in
            if let values = values {
                DispatchQueue.main.async {
                    // Sort customers alphabetically by name (assuming name is in the second column, index 1)
                    self.customersData = values.sorted(by: { $0[1].localizedCaseInsensitiveCompare($1[1]) == .orderedAscending })
                    print("Customer Data (sorted): \(values)")
                }
            } else {
                print("Failed to fetch data from Google Sheets")
            }
        }
    }
}

struct CustomersListView_Previews: PreviewProvider {
    static var previews: some View {
        CustomersListView()
    }
}
