//
//  SettingsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import SwiftUI
import Foundation

struct SettingsView: View {
	@Binding var nuts: [Nut]
	
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		//formatter.dateStyle = .long
		//formatter.timeStyle = .short
		formatter.dateFormat = "d MMMM YYYY - HH:mm:ss at "
		return formatter
	}()
	
	private let intervalFormatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .short
		return formatter
	}()
	
	@State var delta: TimeInterval = TimeInterval()
	@Environment(\.isEnabled) private var loaded
	
	var body: some View {
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			VStack {
				
				Text("Time since last nut")
				Text(intervalFormatter.string(from: delta) ?? "0")
				
				
				Button {
					print(queryDatabase(searchTerm: "August"))
				} label: {
					Rectangle()
						.fill(Color("BackgroundColor"))
						.frame(width: 100, height: 100)
				}

				
				List {
					ForEach($nuts, editActions: .delete) { $nut in
						ListItem(parsedText: .constant(dateFormatter.string(from: nut.time)))
					}.onDelete(perform: delete)
				}
				
			}.onAppear(perform: {
				Task {
					try await delta = calculateDelta()
				}
			})
			.onChange(of: delta, {
				Task {
					try await delta = calculateDelta()
				}
			})
		}
	}
	
	func delete(at offsets: IndexSet)
	{
		nuts.remove(atOffsets: offsets)
	}
	
	func calculateDelta() async throws -> TimeInterval {
		if (nuts.count > 0)
		{
			return Date.now.timeIntervalSince(nuts[nuts.count-1].time)
		}
		return TimeInterval.zero
	}
	
	func queryDatabase(searchTerm: String) -> [Nut]
	{
		return nuts.filter { dateFormatter.string(from: $0.time).contains(searchTerm) }
	}
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(nuts: .constant(Nut.sampleData))
	}
}

