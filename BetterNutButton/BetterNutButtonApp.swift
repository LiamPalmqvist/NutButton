//
//  BetterNutButtonApp.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import SwiftUI

@main
struct BetterNutButtonApp: App {
	@UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
	@StateObject private var nutStore = NutManager()
	@StateObject private var settingsStore = SettingsManager()
    
	var body: some Scene {
        WindowGroup {
			ContentView(nuts: $nutStore.nuts, appSettings: $settingsStore.settings, settingsManager: .constant(settingsStore)) {
				// Task that runs when the app's state changes to inactive
				Task {
					do {
						try await nutStore.save(nuts: nutStore.nuts)
						try await settingsStore.save(settings: settingsStore.settings)
					} catch {
						fatalError(error.localizedDescription)
					}
				}
			}
			// the task modifier allows for async task calls
			.task {
				do {
					// try to load the data in the store by calling the function that was written earlier
					try await nutStore.load()
					try await settingsStore.load()
				} catch {
					fatalError(error.localizedDescription)
				}
			}
		}
				
	}
    
}
