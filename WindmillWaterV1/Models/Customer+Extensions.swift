import Foundation
import CoreData

extension Customer {
    var dailyDeliveriesList: [DailyDelivery] {
        let set = dailyDeliveries as? Set<DailyDelivery> ?? []
        return Array(set)
    }
}
