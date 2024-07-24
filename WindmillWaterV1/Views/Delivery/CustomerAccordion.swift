import SwiftUI

struct CustomerAccordion: View {
    @ObservedObject var customer: Customer
    @Binding var isExpanded: Bool

    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    self.isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(customer.name ?? "")
                    Spacer()
                    Image(systemName: self.isExpanded ? "chevron.up" : "chevron.down")
                }
            }

            if isExpanded {
                VStack {
                    Group {
                        HStack {
                            Text("5G Reg")
                            TextField("", text: Binding(
                                get: { String(customer.quantityDelivered5GReg) },
                                set: { customer.quantityDelivered5GReg = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("3G Reg")
                            TextField("", text: Binding(
                                get: { String(customer.quantityDelivered3GReg) },
                                set: { customer.quantityDelivered3GReg = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Hg Reg")
                            TextField("", text: Binding(
                                get: { String(customer.quantityDeliveredHgReg) },
                                set: { customer.quantityDeliveredHgReg = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("5G Taos")
                            TextField("", text: Binding(
                                get: { String(customer.quantityDelivered5GTaos) },
                                set: { customer.quantityDelivered5GTaos = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("3G Taos")
                            TextField("", text: Binding(
                                get: { String(customer.quantityDelivered3GTaos) },
                                set: { customer.quantityDelivered3GTaos = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Hg Taos")
                            TextField("", text: Binding(
                                get: { String(customer.quantityDeliveredHgTaos) },
                                set: { customer.quantityDeliveredHgTaos = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("5G Dist")
                            TextField("", text: Binding(
                                get: { String(customer.quantityDelivered5GDist) },
                                set: { customer.quantityDelivered5GDist = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("3G Dist")
                            TextField("", text: Binding(
                                get: { String(customer.quantityDelivered3GDist) },
                                set: { customer.quantityDelivered3GDist = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Hg Dist")
                            TextField("", text: Binding(
                                get: { String(customer.quantityDeliveredHgDist) },
                                set: { customer.quantityDeliveredHgDist = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }

                    Group {
                        HStack {
                            Text("5G Returned")
                            TextField("", text: Binding(
                                get: { String(customer.quantityReturned5G) },
                                set: { customer.quantityReturned5G = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("3G Returned")
                            TextField("", text: Binding(
                                get: { String(customer.quantityReturned3G) },
                                set: { customer.quantityReturned3G = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                        HStack {
                            Text("Hg Returned")
                            TextField("", text: Binding(
                                get: { String(customer.quantityReturnedHg) },
                                set: { customer.quantityReturnedHg = Int16($0) ?? 0 }
                            ))
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}

struct CustomerAccordion_Previews: PreviewProvider {
    static var previews: some View {
        CustomerAccordion(customer: Customer(), isExpanded: .constant(false))
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
