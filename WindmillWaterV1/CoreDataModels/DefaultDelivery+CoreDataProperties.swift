//
//  DefaultDelivery+CoreDataProperties.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/29/24.
//
//

import Foundation
import CoreData


extension DefaultDelivery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DefaultDelivery> {
        return NSFetchRequest<DefaultDelivery>(entityName: "DefaultDelivery")
    }

    @NSManaged public var bottleType: String?
    @NSManaged public var waterType: String?
    @NSManaged public var customer: Customer?
    @NSManaged public var defaultDeliveries: NSSet?

}

// MARK: Generated accessors for defaultDeliveries
extension DefaultDelivery {

    @objc(addDefaultDeliveriesObject:)
    @NSManaged public func addToDefaultDeliveries(_ value: DefaultDelivery)

    @objc(removeDefaultDeliveriesObject:)
    @NSManaged public func removeFromDefaultDeliveries(_ value: DefaultDelivery)

    @objc(addDefaultDeliveries:)
    @NSManaged public func addToDefaultDeliveries(_ values: NSSet)

    @objc(removeDefaultDeliveries:)
    @NSManaged public func removeFromDefaultDeliveries(_ values: NSSet)

}
