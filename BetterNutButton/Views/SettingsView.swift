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
	@Binding var appSettings: AppSettings
	
	@State private var importScreenShowing: Bool = false
	@State private var exportScreenShowing: Bool = false
	@State var exportDocument: NutManager.CSV?
	
	let viewAmounts = ["50", "100", "250", "500", "All"]

	var body: some View {
		
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			ScrollView {
				VStack {
					
					Text("Settings")
						.font(Font.custom("LEMONMILK-Regular", size: 45))
						.padding(.bottom, 10)
						.padding(.top, 30)
						.foregroundColor(Color("TextColor"))
					
					// =======================================
					// This is where the settings are gonna go
					// =======================================
					
					HStack {
						
						Spacer()
						
						Text("History row limit")
							.font(Font.custom("LEMONMILK-Regular", size: 25))
							.frame(width: 280)
							.foregroundColor(Color("TextColor"))
						
						
						Menu {
							Picker(selection: $appSettings.historyRowLimit, label: Text(appSettings.historyRowLimit))
							{
								ForEach(viewAmounts, id: \.self)
								{ value in
									Text(value).tag(value)
								}
							}
							
						} label: {
							
							ZStack {
								Rectangle()
									.fill(Color("ContainerColor"))
									.cornerRadius(45)
									.padding(.all)
									.frame(width: 100, height:80)
								
								Text(appSettings.historyRowLimit)
									.font(Font.custom("LEMONMILK-Regular", size: 25))
									.foregroundColor(Color("TextColor"))
							}
						}.frame(width: 60)
						
						
						Spacer()
						
					}
					
					// =============================
					// UNDO, IMPORT & EXPORT buttons
					// =============================
					
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
						print("Exported")
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
		SettingsView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData)).preferredColorScheme(.dark)
		SettingsView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData)).preferredColorScheme(.light)
	}
}
