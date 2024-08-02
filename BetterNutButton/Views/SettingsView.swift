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
		formatter.allowedUnits = [.day, .hour, .minute, .second]
		formatter.zeroFormattingBehavior = .pad
		formatter.unitsStyle = .short
		return formatter
	}()
	
	@State var delta: TimeInterval = TimeInterval()
	@Environment(\.isEnabled) private var loaded
	
	var body: some View {
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			ScrollView {
				Spacer()
				VStack {
					
					Text("Time since last nut")
						.frame(width: 375)
						.font(Font.custom("LEMONMILK-Regular", size: 30))
						.padding(.bottom, -25.0)
					ZStack {
						Rectangle().foregroundColor(Color("ContainerColor"))
							.frame(width: 375, height: 50)
							.cornerRadius(15)
							.padding(.vertical)
						VStack {
							Text(intervalFormatter.string(from: delta) ?? "0")
								.font(Font.custom("LEMONMILK-Regular", size: 22))
						}
					}

					
					ForEach((0..<nuts.count).reversed(), id: \.self) {index in
						ListItem(parsedDate: .constant(nuts[index].time), assocNut: .constant(index), nuts: $nuts)
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

