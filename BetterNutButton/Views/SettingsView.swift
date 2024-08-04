//
//  SettingsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 03/08/2024.
//

import SwiftUI
import UniformTypeIdentifiers


struct SettingsView: View {
	
	@Binding var nuts: [Nut]
	
	@State private var importScreenShowing: Bool = false
	@State private var exportScreenShowing: Bool = false
	@State var exportDocument: NutManager.CSV?
	

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
					importScreenShowing = true
					print("Imported")
				}, bodyText: "Import", backgroundColor: Color("accentBlue"))
				.fileImporter(
					isPresented: $importScreenShowing,
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
					exportScreenShowing = true
					exportDocument = NutManager().exportNutsToCsv(nuts: nuts)
					//print("Exported", exportDocument)
				}, bodyText: "Export", backgroundColor: Color("accentGreen"))
				.fileExporter(
					isPresented: $exportScreenShowing,
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
		SettingsView(nuts: .constant(Nut.sampleData)).preferredColorScheme(.dark)
		SettingsView(nuts: .constant(Nut.sampleData)).preferredColorScheme(.light)
	}
}
