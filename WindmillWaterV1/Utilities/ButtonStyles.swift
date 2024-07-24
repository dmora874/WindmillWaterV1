import SwiftUI

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct DestructiveButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

struct ButtonStyles_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Button("Primary Button") {}
                .buttonStyle(PrimaryButtonStyle())
            Button("Destructive Button") {}
                .buttonStyle(DestructiveButtonStyle())
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
