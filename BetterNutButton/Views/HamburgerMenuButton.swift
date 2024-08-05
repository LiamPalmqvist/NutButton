//
//  HamburgetMenuButton.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 05/08/2024.
//

import SwiftUI

struct HamburgerMenuButton: View {
	@Binding var nuts: [Nut]
	@Binding var appSettings: AppSettings
	@Binding var settingsManager: SettingsManager
	
	@State var isOpen: Bool = false
	@State var angleOfRotation: Double = 0
	
	var body: some View {
		
		VStack {
			Image(systemName: "arrowtriangle.right.fill")
				.font(.largeTitle.weight(.bold))
				.foregroundColor(Color("TextColor"))
				.frame(width: 40, height: 40)
				.rotationEffect(Angle(degrees: angleOfRotation))
				.onTapGesture {
					isOpen.toggle()
					switch isOpen
					{
					case true:
						print("held")
						withAnimation(.easeIn(duration: 0.1)) {
							angleOfRotation = 90
						}
						
						break;
					case false:
						print("let go")
						withAnimation(.interpolatingSpring(duration: 0.1, bounce: 0.5, initialVelocity: 10))
						{
							angleOfRotation = 0
						}
						
						break;
					}
				}
			
			if (isOpen) {
				
				StatsButton(nuts: $nuts, iconColor: Color("TextColor"))
				HistoryButton(nuts: $nuts, appSettings: $appSettings, iconColor: Color("TextColor"))
				SettingsButton(nuts: $nuts, appSettings: $appSettings, settingsManager: $settingsManager, iconColor: Color("TextColor"))
				
			} else {
				
				StatsButton(nuts: $nuts, iconColor: Color.clear)
				HistoryButton(nuts: $nuts, appSettings: $appSettings, iconColor: Color.clear)
				SettingsButton(nuts: $nuts, appSettings: $appSettings, settingsManager: $settingsManager, iconColor: Color.clear)
			}
			
		}
	}
}

struct HamburgerMenu_Previews: PreviewProvider {
	static var previews: some View {
		HamburgerMenuButton(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData), settingsManager: .constant(SettingsManager()))
	}
}
