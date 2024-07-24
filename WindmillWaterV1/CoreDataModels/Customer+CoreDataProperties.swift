//
//  Customer+CoreDataProperties.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/23/24.
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
    @NSManaged public var paymentMethod: String?
    @NSManaged public var phoneNumber: String?
    @NSManaged public var pricingInformation: String?
    @NSManaged public var notes: String?
    @NSManaged public var routeAssociation: Route?
    @NSManaged public var deliveries: NSSet?

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

extension Customer : Identifiable {

}
