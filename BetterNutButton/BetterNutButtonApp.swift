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
	@StateObject private var store = NutManager()
    
	var body: some Scene {
        WindowGroup {
			ContentView(nuts: $store.nuts) {
				// Task that runs when the app's state changes to inactive
				Task {
					do {
						try await store.save(nuts: store.nuts)
					} catch {
						fatalError(error.localizedDescription)
					}
				}
			}
			// the task modifier allows for async task calls
			.task {
				do {
					// try to load the data in the store by calling the function that was written earlier
					try await store.load()
				} catch {
					fatalError(error.localizedDescription)
				}
			}
		}
				
	}
    
}
