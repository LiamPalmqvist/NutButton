//
//  ListItem.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 01/08/2024.
//

import SwiftUI

struct ListItem: View {
	@Binding var parsedText: String
	
	var body: some View {
		Text(parsedText)
			.listRowBackground(Color("BackgroundColor"))
			
	}
}

struct ListItem_Previews: PreviewProvider {
	static var previews: some View {
		ListItem(parsedText: .constant("Hello"))
			.preferredColorScheme(.light)
	}
}
