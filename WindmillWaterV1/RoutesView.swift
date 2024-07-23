import SwiftUI

struct RoutesView: View {
    var body: some View {
        RoutesListView()
    }
}

struct RoutesView_Previews: PreviewProvider {
    static var previews: some View {
        RoutesView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
