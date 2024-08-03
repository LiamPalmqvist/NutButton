//
//  ContentView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import SwiftUI

struct ContentView: View {
	@Binding var nuts: [Nut]
	@Environment(\.scenePhase) private var scenePhase
	let saveAction: ()-> Void
	
	var body: some View {
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			
			VStack {
				HStack {
					Spacer()
					SettingsButton()
						.padding(.trailing, 20)
				}
				Spacer()
				MainButtonView(nuts: $nuts)
				Text("NUTS")
					.font(Font
						.custom("LEMONMILK-Regular", size: 56))
					.foregroundColor(Color("TextColor"))
				NutCountButtonView(nuts: $nuts)
				Spacer()
				Spacer()
			}
			.onChange(of: scenePhase) {
				if (scenePhase == .inactive) { saveAction() }
			}
		}
		
	}
		
}

struct ContentView_Previews: PreviewProvider {
	// need to provide a constant for the data
	static var previews: some View {
		ContentView(nuts: .constant(Nut.sampleData), saveAction: {})
	}
}
