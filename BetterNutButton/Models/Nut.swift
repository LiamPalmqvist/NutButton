//
//  Nuts.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import Foundation

struct Nut: Identifiable, Codable
{
	// define the values of the data structure
	let id: UUID
	var time: Date
	
	// define the initialiser properties parsed
	init(id: UUID = UUID(), time: Date = Date())
	{
		self.id = id
		self.time = time
	}
}


extension Nut {
	static let sampleData: [Nut] =
	[
		Nut(time: Date.now - 100000),
		Nut(time: Date.now - 10000),
		Nut(time: Date.now - 1000),
		Nut(time: Date.now - 500),
		Nut(time: Date.now)
	]
}
