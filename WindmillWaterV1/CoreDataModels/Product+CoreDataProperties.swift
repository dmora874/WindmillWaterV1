//
//  Product+CoreDataProperties.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/23/24.
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
    @NSManaged public var deliveries: Delivery?

}

extension Product : Identifiable {

}
