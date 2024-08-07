//
//  Extensions.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 07/08/2024.
//

import Foundation
import SwiftUI

extension UIColor {
  static func == (l: UIColor, r: UIColor) -> Bool {
	var r1: CGFloat = 0
	var g1: CGFloat = 0
	var b1: CGFloat = 0
	var a1: CGFloat = 0
	l.getRed(&r1, green: &g1, blue: &b1, alpha: &a1)
	var r2: CGFloat = 0
	var g2: CGFloat = 0
	var b2: CGFloat = 0
	var a2: CGFloat = 0
	r.getRed(&r2, green: &g2, blue: &b2, alpha: &a2)
	return r1 == r2 && g1 == g2 && b1 == b2 && a1 == a2
  }
}
func == (l: UIColor?, r: UIColor?) -> Bool {
  let l = l ?? .clear
  let r = r ?? .clear
  return l == r
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
		var a: CGFloat = 1.0
		
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
			a = CGFloat(rgb & 0x000000FF) / 255.0
		} else {
			return nil
		}
		
		self.init(red: r, green: g, blue: b, opacity: a)
	}
}

extension StringProtocol {
	subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
	subscript(range: Range<Int>) -> SubSequence {
		let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
		return self[startIndex..<index(startIndex, offsetBy: range.count)]
	}
	subscript(range: ClosedRange<Int>) -> SubSequence {
		let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
		return self[startIndex..<index(startIndex, offsetBy: range.count)]
	}
	subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
	subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
	subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}
