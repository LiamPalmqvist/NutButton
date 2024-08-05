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

extension Color {
	func toHex() -> String {
		let uic = UIColor(self)
		guard let components = uic.cgColor.components, components.count >= 3 else {
			return "000000"
		}
		let r = Float(components[0])
		let g = Float(components[1])
		let b = Float(components[2])
		var a = Float(1.0)
		
		if components.count >= 4 {
			a = Float(components[3])
		}
		
		if a != Float(1.0) {
			return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
		} else {
			return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
		}
	}
	
	init?(hex: String) {
		
		var hexSanitised = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		hexSanitised = hexSanitised.replacingOccurrences(of: "#", with: "")
		
		var rgb: UInt64 = 0
		
		var r: CGFloat = 0.0
		var g: CGFloat = 0.0
		var b: CGFloat = 0.0
		var a: CGFloat = 0.0
		
		let length = hexSanitised.count
		guard Scanner(string: hexSanitised).scanHexInt64(&rgb) else { return nil }
		
		if length == 6 {
			r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
			g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
			b = CGFloat(rgb & 0x0000FF) / 255.0
		} else if length == 8 {
			r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
			g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
			b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
			b = CGFloat(rgb & 0x000000FF) / 255.0
		} else {
			return nil
		}
		
		self.init(red: r, green: g, blue: b, opacity: a)
	}
}
