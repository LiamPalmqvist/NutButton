//
//  SettingsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import SwiftUI

struct SettingsView: View {
	@Binding var nuts: [Nut]
	
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateStyle = .long
		formatter.timeStyle = .medium
		return formatter
	}()
	
	var body: some View {
		
		NavigationStack {
			List {
				ForEach($nuts, editActions: .delete) { $nut in
					Text(dateFormatter.string(from: nut.time))
				}.onDelete(perform: delete)
			}
		}
	}
	
	func delete(at offsets: IndexSet)
	{
		nuts.remove(atOffsets: offsets)
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(nuts: .constant(Nut.sampleData))
	}
}

