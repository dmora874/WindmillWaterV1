import SwiftUI

struct RouteDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.userRole) var userRole
    @ObservedObject var route: Route
    @State private var showEditRoute = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(alignment: .leading, spacing: 10) {
                    Text("Identifier: \(route.identifier ?? "")")
                    Text("Date: \(route.date ?? Date(), formatter: itemFormatter)")
                    Text("Status: \(route.isCompleted ? "Completed" : (route.isStarted ? "In Progress" : "Not Started"))")
                        .foregroundColor(route.isCompleted ? .green : (route.isStarted ? .blue : .red))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)

                if userRole == .deliveryManager {
                    Section(header: Text("Customers").font(.headline)) {
                        ForEach(route.customersArray) { customer in
                            NavigationLink(destination: CustomerDetailView(customer: customer)) {
                                VStack(alignment: .leading) {
                                    Text("Name: \(customer.name ?? "Unknown")")
                                    Text("Address: \(customer.address ?? "Unknown")")
                                    Text("Phone: \(customer.phoneNumber ?? "Unknown")")
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .padding(.horizontal)
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
                    .padding()
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
                    .padding()
                }
            }
            .padding()
        }
        .navigationBarTitle("Route Details", displayMode: .inline)
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
