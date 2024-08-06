//
//  Settings.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 05/08/2024.
//

import Foundation
import SwiftUI

struct AppSettings: Codable
{
	// define the values of the data structure
	var accent: String
	var notifications: Bool
	var lockApp: Bool
	var timeFormat: Bool // false for 12hr, true for 24hr
	var november: Bool
	var historyRowLimit: String
	
	// define the initialiser properties parsed
	init( 
		accent: Color = Color.white,
		notifications: Bool = false,
		lockApp: Bool = false,
		timeFormat: Bool = true,
		november: Bool = false,
		historyRowLimit: String = "lmao")
	{
		self.accent = accent.toHex()
		self.notifications = notifications
		self.lockApp = lockApp
		self.timeFormat = timeFormat
		self.november = november
		self.historyRowLimit = historyRowLimit
	}
}


extension AppSettings {
	static let sampleData: AppSettings = AppSettings(
		accent: Color("accentRed"),
		notifications: false,
		lockApp: false,
		timeFormat: true,
		november: false,
		historyRowLimit: "100"
	)
}


