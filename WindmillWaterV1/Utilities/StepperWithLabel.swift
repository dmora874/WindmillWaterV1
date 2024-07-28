import SwiftUI

struct StepperWithLabel: View {
    let label: String
    @Binding var value: Int16

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Stepper(value: $value, in: 0...Int16.max) {
                Text("\(value)")
            }
        }
    }
}
