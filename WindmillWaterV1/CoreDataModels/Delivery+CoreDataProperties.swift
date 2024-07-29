//
//  Delivery+CoreDataProperties.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/29/24.
//
//

import Foundation
import CoreData


extension Delivery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Delivery> {
        return NSFetchRequest<Delivery>(entityName: "Delivery")
    }

    @NSManaged public var date: Date?
    @NSManaged public var notes: String?
    @NSManaged public var quantityDelivered: Int16
    @NSManaged public var quantityDelivered3GDist: Int16
    @NSManaged public var quantityDelivered3GReg: Int16
    @NSManaged public var quantityDelivered3GTaos: Int16
    @NSManaged public var quantityDelivered5GDist: Int16
    @NSManaged public var quantityDelivered5GReg: Int16
    @NSManaged public var quantityDelivered5GTaos: Int16
    @NSManaged public var quantityDeliveredHgDist: Int16
    @NSManaged public var quantityDeliveredHgReg: Int16
    @NSManaged public var quantityDeliveredHgTaos: Int16
    @NSManaged public var quantityReturned: Int16
    @NSManaged public var quantityReturned3G: Int16
    @NSManaged public var quantityReturned5G: Int16
    @NSManaged public var quantityReturnedHg: Int16
    @NSManaged public var customer: Customer?
    @NSManaged public var products: NSSet?
    @NSManaged public var route: Route?

}

// MARK: Generated accessors for products
extension Delivery {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
