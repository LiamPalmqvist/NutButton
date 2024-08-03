//
//  SettingsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 03/08/2024.
//

import SwiftUI

struct SettingsView: View {
	
	
	var body: some View {
		Button()
		{
			
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
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView()
	}
}
