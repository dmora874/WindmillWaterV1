//
//  Product+CoreDataProperties.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/29/24.
//
//

import Foundation
import CoreData


extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: String?
    @NSManaged public var deliveries: NSSet?

}

// MARK: Generated accessors for deliveries
extension Product {

    @objc(addDeliveriesObject:)
    @NSManaged public func addToDeliveries(_ value: Delivery)

    @objc(removeDeliveriesObject:)
    @NSManaged public func removeFromDeliveries(_ value: Delivery)

    @objc(addDeliveries:)
    @NSManaged public func addToDeliveries(_ values: NSSet)

    @objc(removeDeliveries:)
    @NSManaged public func removeFromDeliveries(_ values: NSSet)

}
