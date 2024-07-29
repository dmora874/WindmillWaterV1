//
//  Customer+CoreDataProperties.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/29/24.
//
//

import Foundation
import CoreData


extension Customer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Customer> {
        return NSFetchRequest<Customer>(entityName: "Customer")
    }

    @NSManaged public var address: String?
    @NSManaged public var name: String?
    @NSManaged public var notes: String?
    @NSManaged public var paymentMethod: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var pricingInformation: String?
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
    @NSManaged public var deliveredQuantities: NSObject?
    @NSManaged public var returnedQuantities: NSObject?
    @NSManaged public var deliveries: NSSet?
    @NSManaged public var routeAssociation: Route?
    @NSManaged public var defaultDeliveries: NSSet?
    @NSManaged public var dailyDeliveries: DailyDelivery?

}

// MARK: Generated accessors for deliveries
extension Customer {

    @objc(addDeliveriesObject:)
    @NSManaged public func addToDeliveries(_ value: Delivery)

    @objc(removeDeliveriesObject:)
    @NSManaged public func removeFromDeliveries(_ value: Delivery)

    @objc(addDeliveries:)
    @NSManaged public func addToDeliveries(_ values: NSSet)

    @objc(removeDeliveries:)
    @NSManaged public func removeFromDeliveries(_ values: NSSet)

}

// MARK: Generated accessors for defaultDeliveries
extension Customer {

    @objc(addDefaultDeliveriesObject:)
    @NSManaged public func addToDefaultDeliveries(_ value: DefaultDelivery)

    @objc(removeDefaultDeliveriesObject:)
    @NSManaged public func removeFromDefaultDeliveries(_ value: DefaultDelivery)

    @objc(addDefaultDeliveries:)
    @NSManaged public func addToDefaultDeliveries(_ values: NSSet)

    @objc(removeDefaultDeliveries:)
    @NSManaged public func removeFromDefaultDeliveries(_ values: NSSet)

}
