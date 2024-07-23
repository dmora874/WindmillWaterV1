//
//  WindmillWaterV1App.swift
//  WindmillWaterV1
//
//  Created by Derek Mora on 7/23/24.
//

import SwiftUI

@main
struct WindmillWaterV1App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
