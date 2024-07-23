import Foundation
import CoreData

extension Route {
    var deliveriesArray: [Delivery] {
        let set = deliveries as? Set<Delivery> ?? []
        return set.sorted {
            $0.date ?? Date() < $1.date ?? Date()
        }
    }
}
