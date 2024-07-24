import SwiftUI

struct CustomerDetailView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var customer: Customer
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.userRole) var userRole
    var isCompleted: Bool

    @State private var quantityDelivered5GReg: Int16
    @State private var quantityDelivered3GReg: Int16
    @State private var quantityDeliveredHgReg: Int16
    @State private var quantityDelivered5GTaos: Int16
    @State private var quantityDelivered3GTaos: Int16
    @State private var quantityDeliveredHgTaos: Int16
    @State private var quantityDelivered5GDist: Int16
    @State private var quantityDelivered3GDist: Int16
    @State private var quantityDeliveredHgDist: Int16
    @State private var quantityReturned5G: Int16
    @State private var quantityReturned3G: Int16
    @State private var quantityReturnedHg: Int16

    init(customer: Customer, isCompleted: Bool) {
        self.customer = customer
        self.isCompleted = isCompleted
        _quantityDelivered5GReg = State(initialValue: customer.quantityDelivered5GReg)
        _quantityDelivered3GReg = State(initialValue: customer.quantityDelivered3GReg)
        _quantityDeliveredHgReg = State(initialValue: customer.quantityDeliveredHgReg)
        _quantityDelivered5GTaos = State(initialValue: customer.quantityDelivered5GTaos)
        _quantityDelivered3GTaos = State(initialValue: customer.quantityDelivered3GTaos)
        _quantityDeliveredHgTaos = State(initialValue: customer.quantityDeliveredHgTaos)
        _quantityDelivered5GDist = State(initialValue: customer.quantityDelivered5GDist)
        _quantityDelivered3GDist = State(initialValue: customer.quantityDelivered3GDist)
        _quantityDeliveredHgDist = State(initialValue: customer.quantityDeliveredHgDist)
        _quantityReturned5G = State(initialValue: customer.quantityReturned5G)
        _quantityReturned3G = State(initialValue: customer.quantityReturned3G)
        _quantityReturnedHg = State(initialValue: customer.quantityReturnedHg)
    }

    var body: some View {
        Form {
            Section(header: Text("Customer Details")) {
                Text("Name: \(customer.name ?? "")")
                Text("Address: \(customer.address ?? "")")
                Text("Phone: \(customer.phoneNumber ?? "")")
            }
            
            Section(header: Text("Delivery Quantities")) {
                StepperWithLabel(label: "5G Reg", value: $quantityDelivered5GReg, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "3G Reg", value: $quantityDelivered3GReg, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "Hg Reg", value: $quantityDeliveredHgReg, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "5G Taos", value: $quantityDelivered5GTaos, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "3G Taos", value: $quantityDelivered3GTaos, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "Hg Taos", value: $quantityDeliveredHgTaos, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "5G Dist", value: $quantityDelivered5GDist, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "3G Dist", value: $quantityDelivered3GDist, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "Hg Dist", value: $quantityDeliveredHgDist, isEditable: !(isCompleted && userRole != .admin))
            }

            Section(header: Text("Returned Quantities")) {
                StepperWithLabel(label: "5G", value: $quantityReturned5G, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "3G", value: $quantityReturned3G, isEditable: !(isCompleted && userRole != .admin))
                StepperWithLabel(label: "Hg", value: $quantityReturnedHg, isEditable: !(isCompleted && userRole != .admin))
            }

            if !(isCompleted && userRole != .admin) {
                Button("Save") {
                    saveQuantities()
                    presentationMode.wrappedValue.dismiss()
                }
                .buttonStyle(PrimaryButtonStyle())
            }
        }
        .navigationBarTitle(customer.name ?? "Customer Details")
    }

    private func saveQuantities() {
        customer.quantityDelivered5GReg = quantityDelivered5GReg
        customer.quantityDelivered3GReg = quantityDelivered3GReg
        customer.quantityDeliveredHgReg = quantityDeliveredHgReg
        customer.quantityDelivered5GTaos = quantityDelivered5GTaos
        customer.quantityDelivered3GTaos = quantityDelivered3GTaos
        customer.quantityDeliveredHgTaos = quantityDeliveredHgTaos
        customer.quantityDelivered5GDist = quantityDelivered5GDist
        customer.quantityDelivered3GDist = quantityDelivered3GDist
        customer.quantityDeliveredHgDist = quantityDeliveredHgDist
        customer.quantityReturned5G = quantityReturned5G
        customer.quantityReturned3G = quantityReturned3G
        customer.quantityReturnedHg = quantityReturnedHg

        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct StepperWithLabel: View {
    let label: String
    @Binding var value: Int16
    var isEditable: Bool

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            if isEditable {
                Stepper(value: $value, in: 0...Int16.max) {
                    Text("\(value)")
                }
            } else {
                Text("\(value)")
            }
        }
    }
}
