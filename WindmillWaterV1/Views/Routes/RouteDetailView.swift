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

                if userRole == .deliveryManager {
                    Section(header: Text("Customers")) {
                        ForEach(route.customersList, id: \.self) { customer in
                            VStack(alignment: .leading) {
                                Text("Name: \(customer.name ?? "Unknown")")
                                Text("Address: \(customer.address ?? "Unknown")")
                                Text("Phone: \(customer.phoneNumber ?? "Unknown")")
                                NavigationLink(destination: CustomerDetailView(customer: customer, route: route)) {
                                    Text("Details")
                                }
                            }
                            .padding()
                        }
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
                VStack {
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
                    
                    NavigationLink(destination: DeliverySummaryView(route: route)) {
                        Text("View Summary")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding(.top, 10)
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

// Helper extension to convert NSSet to array
extension Route {
    var customersList: [Customer] {
        let set = customers as? Set<Customer> ?? []
        return Array(set)
    }
}
