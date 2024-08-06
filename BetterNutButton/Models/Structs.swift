//
//  Structs.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 07/08/2024.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct InputDocument: FileDocument {

	static var readableContentTypes: [UTType] { [.commaSeparatedText] }

	var input: String

	init(input: String) {
		self.input = input
	}

	init(configuration: FileDocumentReadConfiguration) throws {
		guard let data = configuration.file.regularFileContents,
			  let string = String(data: data, encoding: .utf8)
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		input = string
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		return FileWrapper(regularFileWithContents: input.data(using: .utf8)!)
	}

}
