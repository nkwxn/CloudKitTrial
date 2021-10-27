//
//  TODOSyncApp.swift
//  Shared
//
//  Created by Nicholas on 25/10/21.
//

import SwiftUI

@main
struct TODOSyncApp: App {
    var body: some Scene {
        WindowGroup {
            #if os(iOS)
            TabView {
                TODOView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("TODO")
                    }
                SignInView()
                    .tabItem {
                        Image(systemName: "person")
                        Text("TODO")
                    }
            }
            #else
            TODOView()
            
            #endif
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
