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
	
	private let intervalFormatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.unitsStyle = .short
		return formatter
	}()
	
	@State var delta: TimeInterval = TimeInterval()
	@Environment(\.isEnabled) private var loaded
	
	var body: some View {
		
		VStack {
			
			Text("Time since last nut")
			Text(intervalFormatter.string(from: delta) ?? "0")
			
			NavigationStack {
				List {
					ForEach($nuts, editActions: .delete) { $nut in
						Text(dateFormatter.string(from: nut.time))
					}.onDelete(perform: delete)
				}
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
}

struct SettingsView_Previews: PreviewProvider {
	static var previews: some View {
		SettingsView(nuts: .constant(Nut.sampleData))
	}
}

