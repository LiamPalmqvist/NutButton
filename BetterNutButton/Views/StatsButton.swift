//
//  StatsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 04/08/2024.
//

import SwiftUI

struct StatsButton: View {
	@Binding var nuts: [Nut]
	@State var isPresentingStats = false
	var body: some View {
		Button()
		{
			isPresentingStats = true
		} label: {
			ZStack {
				Circle()
					.frame(width: 55)
					.foregroundColor(Color("ContainerColor"))
				Image(systemName: "chart.bar.fill")
					.font(.title)
					
					.foregroundColor(Color("TextColor"))
			}
		}
		.sheet(isPresented: $isPresentingStats) {
			SettingsView(nuts: $nuts)
		}
	}
}

struct StatsButton_Previews: PreviewProvider {
	static var previews: some View {
		StatsButton(nuts: .constant(Nut.sampleData))
	}
}
