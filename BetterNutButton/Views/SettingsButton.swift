//
//  SettingsButton.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 03/08/2024.
//

import SwiftUI

struct SettingsButton: View {
	@State var isPresentingSettings = false
	@Binding var nuts: [Nut]
	@Binding var appSettings: AppSettings
	@Binding var settingsManager: SettingsManager
	@State var iconColor: Color
	
	
	var body: some View {
		Button()
		{
			isPresentingSettings = true
		} label: {
			ZStack {
				/*
				Circle()
					.frame(width: 55)
					.foregroundColor(Color("ContainerColor"))
				*/
				Image(systemName: "gear")
					.font(.largeTitle.weight(.bold))
					.rotationEffect(.degrees(45))
					.foregroundColor(iconColor)
					.frame(width: 40, height: 40)
			}
		}
		.sheet(isPresented: $isPresentingSettings) {
			SettingsView(nuts: $nuts, appSettings: $appSettings)
		}
	}
}

struct SettingsButton_Previews: PreviewProvider {
	static var previews: some View {
		SettingsButton(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData), settingsManager: .constant(SettingsManager()), iconColor: Color("TextColor"))
	}
}
