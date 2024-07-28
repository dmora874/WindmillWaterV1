import SwiftUI

struct DefaultDeliveryRow: View {
    @Binding var bottleType: String
    @Binding var waterType: String

    let bottleTypes = ["5G", "3G", "Hg"]
    let waterTypes = ["Reg", "Taos", "Dist"]

    var body: some View {
        HStack {
            Picker("Bottle Type", selection: $bottleType) {
                ForEach(bottleTypes, id: \.self) {
                    Text($0)
                }
            }
            Picker("Water Type", selection: $waterType) {
                ForEach(waterTypes, id: \.self) {
                    Text($0)
                }
            }
        }
    }
}

struct DefaultDeliveryRow_Previews: PreviewProvider {
    static var previews: some View {
        DefaultDeliveryRow(bottleType: .constant("5G"), waterType: .constant("Reg"))
    }
}
