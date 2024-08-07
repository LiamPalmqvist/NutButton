//
//  SettingsManager.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 05/08/2024.
//

import SwiftUI
import UniformTypeIdentifiers

// ObservableObject is a class-constrained protocol for connecting external model data to SwiftUI Views
// Essentially it takes data outside of the non-persistant memory and makes it available to use in SwiftUI Views
class SettingsManager: ObservableObject {
	// the @Published property means that the screen will refresh when the value of the variable changes
	@Published var settings: AppSettings = AppSettings()
	
	// private static function that throws a URL containing the location of
	// the "scrums.data" persistant storage in the user's documents
	// folder in their file browser
	private static func fileURL() throws -> URL {
		try FileManager.default.url(
			for: .documentDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		)
		.appendingPathComponent("settings.data")
	}
	
	// this is an async function (to prioritise loading the user's View)
	// that will look for the "nuts.data" file in the user's documents
	// folder to load the persistant data.
	func load() async throws {
		// Create a task to run async
		let task = Task<AppSettings, Error> {
			// grab the URL from the fileURL() function
			let fileURL = try Self.fileURL()
			// try to retrieve data from the requested file, if none exists, return the sample data
			guard let data = try? Data(contentsOf: fileURL) else {
				return AppSettings.sampleData
			}
			// run a json decoder to decode the data if exists
			let allSettings: AppSettings = try JSONDecoder().decode(AppSettings.self, from: data)
			
			return allSettings
		}
		// finally, run the task async and return the value
		let settings = try await task.value
		
		self.settings = settings
	}
	
	// Actually saving the data
	// This function is async for the same reason as earlier
	func save(settings: AppSettings) async throws {
		// no need to wait for errors in this task and no need to enter any data
		let task = Task {
			// encode the data as a JSON
			let data = try JSONEncoder().encode(settings)
			// grab the URL
			let outFile = try Self.fileURL()
			// try to save the data to the file
			// if it doesn't exist, it will ater this operation
			try data.write(to: outFile)
		}
		// the "_" means we aren't interested in the result of the task
		_ = try await task.value
	}
	
}
