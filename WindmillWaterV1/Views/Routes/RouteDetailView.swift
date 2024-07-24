import SwiftUI

struct RouteDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.userRole) var userRole
    @ObservedObject var route: Route
    @State private var showEditRoute = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Route Details")) {
                    Text("Identifier: \(route.identifier ?? "")")
                    Text("Date: \(route.date ?? Date(), formatter: itemFormatter)")
                    Text("Status: \(route.isCompleted ? "Completed" : (route.isStarted ? "In Progress" : "Not Started"))")
                        .foregroundColor(route.isCompleted ? .green : (route.isStarted ? .blue : .red))
                }

                Section(header: Text("Customers")) {
                    ForEach(route.customersArray) { customer in
                        VStack(alignment: .leading) {
                            Text("Name: \(customer.name ?? "Unknown")")
                            Text("Address: \(customer.address ?? "Unknown")")
                            Text("Phone: \(customer.phoneNumber ?? "Unknown")")
                            if userRole == .admin || !route.isCompleted {
                                NavigationLink(destination: CustomerDetailView(customer: customer)) {
                                    Text("Details")
                                }
                            } else {
                                Text("5G Reg: \(customer.quantityDelivered5GReg)")
                                Text("3G Reg: \(customer.quantityDelivered3GReg)")
                                Text("Hg Reg: \(customer.quantityDeliveredHgReg)")
                                Text("5G Taos: \(customer.quantityDelivered5GTaos)")
                                Text("3G Taos: \(customer.quantityDelivered3GTaos)")
                                Text("Hg Taos: \(customer.quantityDeliveredHgTaos)")
                                Text("5G Dist: \(customer.quantityDelivered5GDist)")
                                Text("3G Dist: \(customer.quantityDelivered3GDist)")
                                Text("Hg Dist: \(customer.quantityDeliveredHgDist)")
                                Text("5G Returned: \(customer.quantityReturned5G)")
                                Text("3G Returned: \(customer.quantityReturned3G)")
                                Text("Hg Returned: \(customer.quantityReturnedHg)")
                            }
                        }
                        .padding()
                    }
                }
            }

            if userRole == .admin {
                HStack {
                    NavigationLink(destination: EditRouteView(route: route), isActive: $showEditRoute) {
                        Button("Edit Route") {
                            showEditRoute = true
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }

                    Button("Delete Route") {
                        deleteRoute()
                    }
                    .buttonStyle(DestructiveButtonStyle())
                }
            }

            if userRole == .deliveryManager {
                HStack {
                    if !route.isStarted {
                        Button("Start Route") {
                            route.isStarted = true
                            saveContext()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    } else if route.isStarted && !route.isCompleted {
                        Button("Complete Route") {
                            route.isCompleted = true
                            saveContext()
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
        }
        .navigationBarTitle("Route Details")
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    private func deleteRoute() {
        viewContext.delete(route)
        saveContext()
        presentationMode.wrappedValue.dismiss()
    }
}
