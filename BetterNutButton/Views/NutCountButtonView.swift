//
//  NutCountButtonView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import SwiftUI

struct NutCountButtonView: View {
	@Binding var nuts: [Nut]
	@State private var isPresentingSettings = false
	
	var body: some View {
		Button {
			isPresentingSettings = true
		} label: {
			ZStack {
				Rectangle()
					.fill(.clear)
					.cornerRadius(45)
					.padding(.all)
					.frame(width: 150, height:100)
				
				Text(String(nuts.count))
					.fontWeight(.bold)
					.font(.system(size: 40))
					.padding(.all)
					.padding(.horizontal)
					.background(Color("ContainerColor"))
					.cornerRadius(45)
			}
		}.sheet(isPresented: $isPresentingSettings) {
			SettingsView(nuts: $nuts)
		}
	}
}

struct NutCountButtonView_Previews: PreviewProvider {
	static var previews: some View {
		NutCountButtonView(nuts: .constant(Nut.sampleData))
	}
}
