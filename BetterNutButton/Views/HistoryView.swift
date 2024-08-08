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
	@Binding var appSettings: AppSettings
	
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
	
	@State private var delta: TimeInterval = TimeInterval()
	@State private var showingExporter = false
	@State private var showingCalendar = false
	@State private var pickedDate: Date = Date()
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
						RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
							.foregroundColor(Color("ContainerColor"))
							.frame(width: 375, height: 50)
							.clipShape(.buttonBorder)
							.padding(.vertical)
							VStack {
								Text(intervalFormatter.string(from: delta)?
										.replacingOccurrences(of: " days, ", with: " : ")
										.replacingOccurrences(of: " day, ", with: " : ")
										.replacingOccurrences(of: " hrs, ", with: " : ")
										.replacingOccurrences(of: " hr, ", with: " : ")
										.replacingOccurrences(of: " mins, ", with: " : ")
										.replacingOccurrences(of: " min., ", with: " : ")
										.replacingOccurrences(of: " min, ", with: " : ")
										.replacingOccurrences(of: "secs", with: "")
										.replacingOccurrences(of: "sec", with: "")
										.replacingOccurrences(of: ".", with: "") ?? "0")
									.font(Font.custom("LEMONMILK-Regular", size: 30))
									.foregroundColor(Color("TextColor"))
						}
					}
					
					UIButton(action: {
						showingCalendar.toggle()
						print("Added")
					}, bodyText: "add nut", backgroundColor: Color(hex: appSettings.accent))
					.sheet(isPresented: $showingCalendar) {
						CalendarView(nuts: $nuts, appSettings: $appSettings, showingCalendar: $showingCalendar)
						}
					
					UIButton(action: {
						if (nuts.count > 0) {
							nuts.remove(at: nuts.count-1)
						}
						print("Undid")
					}, bodyText: "Undo", backgroundColor: Color(hex: appSettings.accent))
					
					if (nuts.count != 0) {
						Text(calculateMonth(date: nuts[nuts.count-1].time) + " " + dateFormatter.string(from: nuts[nuts.count-1].time).components(separatedBy: " ")[2])
							.font(Font.custom("LEMONMILK-Regular", size: 35))
							.frame(width: 350, alignment: .leading)
							.padding(.bottom, -10)
							.padding(.top)
							.foregroundColor(Color("TextColor"))
					}
					
					if (appSettings.historyRowLimit != "All" && nuts.count > 0 && nuts.count > Int(appSettings.historyRowLimit)!) {
						
						ListItem(parsedDate: .constant(nuts.last!.time), assocNut: .constant(nuts.count-1), nuts: $nuts, appSettings: .constant(appSettings))
						
						ForEach((0..<Int(appSettings.historyRowLimit)!), id: \.self) {index in
							
							// calculate the month
							if (index > 1) {
								if (calculateMonth(date: nuts[nuts.count-index].time) != calculateMonth(date: nuts[nuts.count-(index-1)].time))
								{
									Text(calculateMonth(date: nuts[nuts.count-index].time) + " " + dateFormatter.string(from: nuts[nuts.count-index].time).components(separatedBy: " ")[2])
										.font(Font.custom("LEMONMILK-Regular", size: 35))
										.frame(width: 350, alignment: .leading)
										.padding(.bottom, -10)
										.foregroundColor(Color("TextColor"))
								}
								
								ListItem(parsedDate: .constant(nuts[nuts.count-index].time), assocNut: .constant(nuts.count-index), nuts: $nuts, appSettings: .constant(appSettings))
							}
								
						}
					} else {
						ForEach((0..<nuts.count).reversed(), id: \.self) {index in
			
							if (index < nuts.count-1) {
								if (calculateMonth(date: nuts[index].time) != calculateMonth(date: nuts[index+1].time))
								{
									Text(calculateMonth(date: nuts[index].time) + " " + dateFormatter.string(from: nuts[index].time).components(separatedBy: " ")[2])
										.font(Font.custom("LEMONMILK-Regular", size: 35))
										.frame(width: 350, alignment: .leading)
										.padding(.bottom, -10)
										.foregroundColor(Color("TextColor"))
								}
							}
							
							ListItem(parsedDate: .constant(nuts[index].time), assocNut: .constant(index), nuts: $nuts, appSettings: .constant(appSettings))
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
		HistoryView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData)).preferredColorScheme(.dark)
	}
}

