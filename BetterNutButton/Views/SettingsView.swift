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
	let tintColours = [Color("accentBlue"), Color("accentCyan"), Color("accentGreen"), Color("accentOrange"), Color("accentPurple"), Color("accentRed")]
	
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
						Text("History row limit")
							.font(Font.custom("LEMONMILK-Regular", size: 25))
							.frame(width: 280)
							.foregroundColor(Color("TextColor"))
							.padding(3)
						
						Spacer()
						
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
							.padding(.trailing, 20)
					}.padding(.bottom, -10)
					
					HStack {
						Text("App Tint Colour")
							.font(Font.custom("LEMONMILK-Regular", size: 25))
							.foregroundColor(Color("TextColor"))
						Spacer()
					}
					.padding(.leading, 20)
					.padding(.bottom, -5)
					
					HStack {
						ForEach(tintColours, id: \.self) { colour in
							Button(action: {appSettings.accent = colour.toHex(); print(appSettings.accent)}, label: {

								Circle()
									.foregroundColor(colour)
									.frame(width: 50)
									.padding(.horizontal, 3)

							})
						}
					}.padding(.bottom)
					
					// =============================
					// UNDO, IMPORT & EXPORT buttons
					// =============================
					
					UIButton(action: {
						importScreenShowing = true
						print("Imported")
					}, bodyText: "Import", backgroundColor: Color(hex: appSettings.accent))
					.fileImporter(
						isPresented: $importScreenShowing,
						allowedContentTypes: [.commaSeparatedText],
						allowsMultipleSelection: false) { result in
							do {
								guard let selectedFile: URL = try result.get().first else { return }
								if selectedFile.startAccessingSecurityScopedResource() {
									guard let input = String(data: try Data(contentsOf: selectedFile), encoding: .utf8) else { return }
											defer { selectedFile.stopAccessingSecurityScopedResource() }
									nuts = NutManager().importCSVtoNuts(stringCSV: input)
									selectedFile.stopAccessingSecurityScopedResource()
								} else { return }
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
					}, bodyText: "Export", backgroundColor: Color(hex: appSettings.accent))
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
					}, bodyText: "Reset", backgroundColor: Color(hex: appSettings.accent))
					
					Spacer()
						.padding(.bottom, 200)
					Text("Version 0.7.2a")
				}
				.padding(.top)
			}
		}
		
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData)).preferredColorScheme(.dark)
	}
}
