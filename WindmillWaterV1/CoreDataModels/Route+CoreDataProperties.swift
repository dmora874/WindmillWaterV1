//
//  Route+CoreDataProperties.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/23/24.
//
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var identifier: String?
    @NSManaged public var date: Date?
    @NSManaged public var isStarted: Bool
    @NSManaged public var isCompleted: Bool
    @NSManaged public var customers: NSSet?
    @NSManaged public var deliveries: NSSet?

}

// MARK: Generated accessors for customers
extension Route {

    @objc(addCustomersObject:)
    @NSManaged public func addToCustomers(_ value: Customer)

    @objc(removeCustomersObject:)
    @NSManaged public func removeFromCustomers(_ value: Customer)

    @objc(addCustomers:)
    @NSManaged public func addToCustomers(_ values: NSSet)

    @objc(removeCustomers:)
    @NSManaged public func removeFromCustomers(_ values: NSSet)

}

// MARK: Generated accessors for deliveries
extension Route {

    @objc(addDeliveriesObject:)
    @NSManaged public func addToDeliveries(_ value: Delivery)

    @objc(removeDeliveriesObject:)
    @NSManaged public func removeFromDeliveries(_ value: Delivery)

    @objc(addDeliveries:)
    @NSManaged public func addToDeliveries(_ values: NSSet)

    @objc(removeDeliveries:)
    @NSManaged public func removeFromDeliveries(_ values: NSSet)

}

extension Route : Identifiable {

}
