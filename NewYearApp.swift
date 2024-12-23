//
//  NewYearApp.swift
//  NewYear
//
//  Created by BARAN DALBUDAK on 23.12.2024.
//

import SwiftUI
import SwiftData

@main
struct NewYearApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Goal.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView(sharedModelContainer: sharedModelContainer)
                .modelContainer(sharedModelContainer)
        }
        .windowStyle(.hiddenTitleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 900, height: 600)
        .commands {
            CommandGroup(replacing: .newItem) {}
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "/*"))
        .defaultAppStorage(.standard)
    }
}
