//
//  StatsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 04/08/2024.
//

import SwiftUI

struct StatsButton: View {
	@Binding var nuts: [Nut]
	@Binding var appSettings: AppSettings
	@State var isPresentingStats = false
	@State var iconColor: Color
	
	var body: some View {
		Button()
		{
			isPresentingStats = true
		} label: {
			ZStack {
				/*
				Circle()
					.frame(width: 55)
					.foregroundColor(Color("ContainerColor"))
				*/
				Image(systemName: "chart.bar.fill")
					.font(.title)
					.frame(width: 40, height: 40)
					.foregroundColor(iconColor)
			}
		}
		.sheet(isPresented: $isPresentingStats) {
			StatsView(nuts: $nuts, appSettings: $appSettings)
		}
	}
	
}

struct StatsButton_Previews: PreviewProvider {
	static var previews: some View {
		StatsButton(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData), iconColor: Color("TextColor"))
	}
}
