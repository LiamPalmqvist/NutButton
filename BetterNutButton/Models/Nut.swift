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
	
	static var newNut: Nut {
		Nut(time: Date.now)
	}
}


extension Nut {
	static let sampleData: [Nut] =
	[
		Nut(time: Date.now),
		Nut(time: Date.now - 50),
		Nut(time: Date.now - 1000)
	]
}
