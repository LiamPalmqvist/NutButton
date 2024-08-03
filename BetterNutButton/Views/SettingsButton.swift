//
//  SettingsButton.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 03/08/2024.
//

import SwiftUI

struct SettingsButton: View {
	@State var isPresentingSettings = false
	
	var body: some View {
		Button()
		{
			isPresentingSettings = true
		} label: {
			ZStack {
				Circle()
					.frame(width: 55)
					.foregroundColor(Color("ContainerColor"))
				Image(systemName: "gear")
					.font(.largeTitle.weight(.bold))
					.rotationEffect(.degrees(45))
					.foregroundColor(Color("TextColor"))
			}
		}
		.sheet(isPresented: $isPresentingSettings) {
			SettingsView()
		}
	}
}

struct SettingsButton_Previews: PreviewProvider {
	static var previews: some View {
		SettingsButton()
	}
}
