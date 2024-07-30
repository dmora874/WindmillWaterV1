import SwiftUI

struct MainView: View {
    @State private var userRole: UserRole? = nil

    var body: some View {
        NavigationView {
            VStack {
                if userRole == nil {
                    VStack(spacing: 20) {
                        Image(systemName: "wind")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(height: 80)
                            .foregroundColor(.blue)
                            .padding(.bottom, 20)
                        
                        Text("Windmill Water")
                            .font(.largeTitle)
                            .bold()
                            .padding(.bottom, 40)
                        
                        loginButton(title: "Admin Login", action: { userRole = .admin })
                        loginButton(title: "Delivery Manager Login", action: { userRole = .deliveryManager })
                        loginButton(title: "Warehouse Manager Login", action: { userRole = .warehouseManager })
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20)
                } else {
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            if userRole == .admin || userRole == .deliveryManager {
                                simpleGridItem(title: "View Customers", icon: "person.3.fill", destination: CustomersListView())
                            }

                            if userRole == .admin || userRole == .deliveryManager {
                                simpleGridItem(title: "View Routes", icon: "map.fill", destination: RoutesView())
                            }

                            if userRole == .admin || userRole == .warehouseManager {
                                simpleGridItem(title: "View Deliveries", icon: "shippingbox.fill", destination: DeliveriesView())
                            }

                            if userRole == .admin {
                                simpleGridItem(title: "View Products", icon: "cart.fill", destination: ManageProductsView())
                            }
                        }
                        .padding()
                    }
                    .navigationBarTitle("Windmill Water Delivery", displayMode: .inline)
                    .navigationBarItems(trailing: Button(action: { userRole = nil }) {
                        Text("Logout")
                            .foregroundColor(.red)
                    })
                }
            }
            .padding()
            .navigationTitle("User Role Selection")
            .background(Color(.systemGray6).edgesIgnoringSafeArea(.all))
        }
        .environment(\.userRole, userRole)
    }

    private func loginButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.gray.opacity(0.2))
                .foregroundColor(.black)
                .cornerRadius(10)
        }
    }

    private func simpleGridItem<Content: View>(title: String, icon: String, destination: Content) -> some View {
        NavigationLink(destination: destination) {
            VStack {
                Image(systemName: icon)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 50)
                    .foregroundColor(.blue)
                Text(title)
                    .font(.headline)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
            }
            .padding()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
