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
                        NavigationLink(destination: CustomerDetailView(customer: customer, isCompleted: route.isCompleted)) {
                            Text(customer.name ?? "")
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
