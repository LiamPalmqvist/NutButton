//
//  SettingsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import SwiftUI
import Foundation

struct HistoryView: View {
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
	@State private var showingExporter = false
	@Environment(\.isEnabled) private var loaded
	
	var body: some View {
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			ScrollView {
				Spacer()
				VStack {
					
					Text("History")
						.font(Font.custom("LEMONMILK-Regular", size: 45))
						.padding(.bottom, 10)
						.padding(.top, 30)
						.foregroundColor(Color("TextColor"))
					
					Text("Time since last nut")
						.font(Font.custom("LEMONMILK-Regular", size: 30))
						.padding(.bottom, -25.0)
						.foregroundColor(Color("TextColor"))
					ZStack {
						Rectangle().foregroundColor(Color("ContainerColor"))
							.frame(width: 375, height: 50)
							.cornerRadius(15)
							.padding(.vertical)
						VStack {
							Text(intervalFormatter.string(from: delta) ?? "0")
								.font(Font.custom("LEMONMILK-Regular", size: 22))
								.foregroundColor(Color("TextColor"))
						}
					}
					
					if (nuts.count != 0) {
						Text(calculateMonth(date: nuts[nuts.count-1].time) + " " + dateFormatter.string(from: nuts[nuts.count-1].time).components(separatedBy: " ")[2])
							.font(Font.custom("LEMONMILK-Regular", size: 35))
							.frame(width: 350, alignment: .leading)
							.padding(.bottom, -10)
							.foregroundColor(Color("TextColor"))
					}
					ForEach((0..<nuts.count).reversed(), id: \.self) {index in
		
						if (index < nuts.count-1) {
							if (calculateMonth(date: nuts[index].time) != calculateMonth(date: nuts[index+1].time))
							{
								Text(calculateMonth(date: nuts[index].time) + " " + dateFormatter.string(from: nuts[index].time).components(separatedBy: " ")[2])
									.font(Font.custom("LEMONMILK-Regular", size: 35))
									.frame(width: 350, alignment: .leading)
									.padding(.bottom, -10)
							}
						}
						
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
	
	func calculateMonth(date: Date) -> String
	{
		return dateFormatter.string(from: date).components(separatedBy: " ")[1]
	}
}

struct HistoryView_Previews: PreviewProvider {
	static var previews: some View {
		HistoryView(nuts: .constant(Nut.sampleData)).preferredColorScheme(.dark)
		HistoryView(nuts: .constant(Nut.sampleData)).preferredColorScheme(.light)
	}
}

