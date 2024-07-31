import SwiftUI

struct StepperWithLabel: View {
    let label: String
    @Binding var value: Int16
    @State private var isEditing = false

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
            Spacer()
            HStack {
                Stepper("", value: $value)
                    .labelsHidden()
                TextField("", value: $value, formatter: NumberFormatter())
                    .frame(width: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .multilineTextAlignment(.center)
                    .keyboardType(.numberPad)
                    .onTapGesture {
                        isEditing = true
                    }
            }
        }
        .padding()
    }
}
