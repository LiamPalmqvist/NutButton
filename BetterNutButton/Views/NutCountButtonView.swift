//
//  NutCountButtonView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import SwiftUI

struct NutCountButtonView: View {
	@Binding var nuts: [Nut]
	@Binding var appSettings: AppSettings
	@State private var isPresentingHistory = false
	
	var body: some View {
		Button {
			isPresentingHistory = true
		} label: {
			ZStack {
				Text(String(nuts.count))
					.fontWeight(.bold)
					.font(.system(size: 40))
					.padding(.all)
					.padding(.horizontal)
					.background(Color("ContainerColor"))
					.foregroundColor(Color("TextColor"))
					.cornerRadius(45)
			}
		}.sheet(isPresented: $isPresentingHistory) {
			HistoryView(nuts: $nuts, appSettings: $appSettings)
		}
	}
}

struct NutCountButtonView_Previews: PreviewProvider {
	static var previews: some View {
		NutCountButtonView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData)).preferredColorScheme(.dark)
		NutCountButtonView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData)).preferredColorScheme(.light)
	}
}
