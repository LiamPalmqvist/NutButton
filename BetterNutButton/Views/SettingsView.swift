//
//  SettingsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 03/08/2024.
//

import SwiftUI
import UniformTypeIdentifiers


struct SettingsView: View {

	@State private var fileScreenShowing: Bool = false
	@State private var _exportDocument: FileDocument
	
	private var exportDocument: FileDocument {
		return _exportDocument
	}
	
	init(fileScreenShowing: Bool = false, _exportDocument: FileDocument = NutManager.CSV(csvRows: ""), nuts: [Nut]) {
		self.fileScreenShowing = fileScreenShowing
		self._exportDocument = _exportDocument
		self.nuts = nuts
	}
	
	@Binding var nuts: [Nut]
	var body: some View {
		
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			
			VStack {
				
				UIButton(action: {
					if (nuts.count > 0) {
						nuts.remove(at: nuts.count-1)
					}
					print("Undid")
				}, bodyText: "Undo", backgroundColor: Color("accentRed"))
				
				
				
				UIButton(action: {
					fileScreenShowing = true
					print("Imported")
				}, bodyText: "Import", backgroundColor: Color("accentBlue"))
				.fileImporter(
					isPresented: $fileScreenShowing,
					allowedContentTypes: [.commaSeparatedText],
					allowsMultipleSelection: false) { result in
						do {
							guard let selectedFile: URL = try result.get().first else { return }
							guard let input = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
							
							nuts = NutManager().importCSVtoNuts(stringCSV: input)
						} catch {
							// Handle failure
							print("Unable to read file contents")
							print(error.localizedDescription)
						}
					}
				
				UIButton(action: {
					fileScreenShowing = true
					_exportDocument = NutManager().exportNutsToCsv(nuts: nuts)
					print("Exported")
				}, bodyText: "Export", backgroundColor: Color("accentGreen"))
				.fileExporter(
					isPresented: $fileScreenShowing,
					document: exportDocument,
					contentType: .commaSeparatedText,
					defaultFilename: "nuts.csv") { result in
						if case .failure(let error) = result {
							print(error.localizedDescription)
						}
					}
					
				
				UIButton(action: {
					nuts.removeAll()
				}, bodyText: "Reset", backgroundColor: Color("accentPurple"))
					
				
				Spacer()
				
			}
			.padding(.top)
		}
	}
}

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

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(nuts: Nut.sampleData).preferredColorScheme(.dark)
		SettingsView(nuts: Nut.sampleData).preferredColorScheme(.light)
	}
}
