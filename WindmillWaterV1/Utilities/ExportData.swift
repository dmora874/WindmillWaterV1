import Foundation
import CoreData

class ExportData {
    static func exportCustomers(context: NSManagedObjectContext) -> String {
        let fetchRequest: NSFetchRequest<Customer> = Customer.fetchRequest()
        var csvText = "Name,Address,Phone Number,Notes,Payment Method,Pricing Information\n"

        do {
            let customers = try context.fetch(fetchRequest)
            for customer in customers {
                let newLine = "\(customer.name ?? ""),\(customer.address ?? ""),\(customer.phoneNumber ?? ""),\(customer.notes ?? ""),\(customer.paymentMethod ?? ""),\(customer.pricingInformation ?? "")\n"
                csvText.append(newLine)
            }
        } catch {
            print("Failed to fetch customers: \(error)")
        }

        return csvText
    }
}
