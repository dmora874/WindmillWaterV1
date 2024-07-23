//
//  Delivery+CoreDataProperties.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/23/24.
//
//

import Foundation
import CoreData


extension Delivery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Delivery> {
        return NSFetchRequest<Delivery>(entityName: "Delivery")
    }

    @NSManaged public var date: Date?
    @NSManaged public var quantityDelivered: Int16
    @NSManaged public var quantityReturned: Int16
    @NSManaged public var notes: String?
    @NSManaged public var customer: Customer?
    @NSManaged public var route: Route?
    @NSManaged public var products: Product?

}

extension Delivery : Identifiable {

}
