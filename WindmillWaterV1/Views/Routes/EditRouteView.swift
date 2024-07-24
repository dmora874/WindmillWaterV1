import SwiftUI

struct EditRouteView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var route: Route
    @State private var identifier: String
    @State private var date: Date

    init(route: Route) {
        self.route = route
        _identifier = State(initialValue: route.identifier ?? "")
        _date = State(initialValue: route.date ?? Date())
    }

    var body: some View {
        Form {
            Section(header: Text("Route Details")) {
                TextField("Identifier", text: $identifier)
                DatePicker("Date", selection: $date, displayedComponents: .date)
            }

            Button("Save") {
                route.identifier = identifier
                route.date = date
                saveContext()
                presentationMode.wrappedValue.dismiss()
            }
            .buttonStyle(PrimaryButtonStyle())
        }
        .navigationBarTitle("Edit Route")
    }

    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
