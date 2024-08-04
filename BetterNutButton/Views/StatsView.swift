//
//  StatsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 04/08/2024.
//

import SwiftUI

struct StatsView: View {
	@Binding var nuts: [Nut]
	
	var body: some View {
		StatsButton(nuts: $nuts)
	}
}

struct StatsView_Previews: PreviewProvider {
	static var previews: some View {
		StatsView(nuts: .constant(Nut.sampleData))
	}
}
