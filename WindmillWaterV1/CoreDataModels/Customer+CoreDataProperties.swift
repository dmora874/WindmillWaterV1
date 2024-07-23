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
    @NSManaged public var deliveries: Delivery?

}

extension Customer : Identifiable {

}
