//
//  SettingsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 03/08/2024.
//

import SwiftUI

struct SettingsView: View {
	
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
					print("Imported") }, bodyText: "Import", backgroundColor: Color("accentBlue"))
					
				UIButton(action: {
					print("Exported") }, bodyText: "Export", backgroundColor: Color("accentGreen"))
					
				
				UIButton(action: {
					nuts.removeAll()
				}, bodyText: "Reset", backgroundColor: Color("accentPurple"))
					
				
				Spacer()
				
			}
			.padding(.top)
		}
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(nuts: .constant(Nut.sampleData)).preferredColorScheme(.dark)
		SettingsView(nuts: .constant(Nut.sampleData)).preferredColorScheme(.light)
	}
}
