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
    @NSManaged public var date: String?
    @NSManaged public var customers: Customer?
    @NSManaged public var deliveries: Delivery?

}

extension Route : Identifiable {

}
