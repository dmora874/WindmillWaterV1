import SwiftUI

struct ProductSelectionRow: View {
    var product: Product
    var isSelected: Bool
    var action: () -> Void

    var body: some View {
        Button(action: self.action) {
            HStack {
                Text(product.name ?? "")
                if self.isSelected {
                    Spacer()
                    Image(systemName: "checkmark")
                }
            }
        }
    }
}

struct ProductSelectionRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductSelectionRow(product: Product(), isSelected: true, action: {})
    }
}
