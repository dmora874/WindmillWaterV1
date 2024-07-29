//
//  DailyDelivery+CoreDataProperties.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/29/24.
//
//

import Foundation
import CoreData


extension DailyDelivery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DailyDelivery> {
        return NSFetchRequest<DailyDelivery>(entityName: "DailyDelivery")
    }

    @NSManaged public var date: Date?
    @NSManaged public var bottleType: String?
    @NSManaged public var waterType: String?
    @NSManaged public var deliveredQuantity: Int16
    @NSManaged public var returnedQuantity: Int16
    @NSManaged public var customer: Customer?
    @NSManaged public var route: Route?
    @NSManaged public var dailyDeliveries: DailyDelivery?

}
