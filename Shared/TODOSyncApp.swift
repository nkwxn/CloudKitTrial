//
//  TODOSyncApp.swift
//  Shared
//
//  Created by Nicholas on 25/10/21.
//

import SwiftUI

@main
struct TODOSyncApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
