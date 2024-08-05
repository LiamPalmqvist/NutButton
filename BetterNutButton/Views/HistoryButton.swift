//
//  HistoryButton.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 05/08/2024.
//

import SwiftUI

struct HistoryButton: View {
	@Binding var nuts: [Nut]
	@Binding var appSettings: AppSettings
	@State var isPresentingHistory = false
	@State var iconColor: Color
	
	var body: some View {
		Button()
		{
			isPresentingHistory = true
		} label: {
			ZStack {
				/*Circle()
					.frame(width: 55)
					.foregroundColor(Color("ContainerColor"))
				*/
				 Image(systemName: "book.fill")
					.font(.title)
					.frame(width: 40, height: 40)
					.foregroundColor(iconColor)
			}
		}
		.sheet(isPresented: $isPresentingHistory) {
			HistoryView(nuts: $nuts, appSettings: $appSettings)
		}
	}
	
}

struct HistoryButton_Previews: PreviewProvider {
	static var previews: some View {
		HistoryButton(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData), iconColor: Color("TextColor"))
	}
}

