//
//  StatsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 04/08/2024.
//

import Charts
import SwiftUI

struct ChartData {
	var timeDate: String
	var count: Int
}

struct StatsView: View {
	@Binding var nuts: [Nut]
	@Binding var appSettings: AppSettings
	
	@State var delta: TimeInterval = TimeInterval()
	@State var nutsInYear: Int = 0
	@State var timesPerMonthData: [ChartData] = []
	
	var body: some View {
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			
			VStack {
				Text("Insights")
					.font(Font.custom("LEMONMILK-Regular", size: 45))
					.padding(.bottom, 10)
					.padding(.top, 30)
					.foregroundColor(Color("TextColor"))
				
				Text("Average nut interval")
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
						Text(intervalFormatter.string(from: delta) ?? "0")
							.font(Font.custom("LEMONMILK-Regular", size: 22))
							.foregroundColor(Color("TextColor"))
					}
				}
				.onAppear(perform: {
					Task {
						delta = calculateAverageInterval(nuts: nuts)
						nutsInYear = calculateNutsInYear(nuts: nuts)
					}
				})
				
				Text("Total nuts in year")
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
						Text(String(nutsInYear))
							.font(Font.custom("LEMONMILK-Regular", size: 22))
							.foregroundColor(Color("TextColor"))
					}
				}
				.onAppear(perform: {
					Task {
						if (nuts.count > 1) {
							delta = calculateAverageInterval(nuts: nuts)
							nutsInYear = calculateNutsInYear(nuts: nuts)
							timesPerMonthData = calculateNutsPerMonth(nuts: nuts)
						}
						
						print(timesPerMonthData)
					}
				})
				
				if (nuts.count > 0) {
					Chart(timesPerMonthData, id: \.timeDate) { item in
						LineMark (
							x: .value("Month", item.timeDate),
							y: .value("Count", item.count)
						)
						.foregroundStyle(Color(hex: appSettings.accent)!)
						.lineStyle(.init(lineWidth: 5))
						
					}
				}
				
				Spacer()
			}
		}
	}
	
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		//formatter.dateStyle = .long
		//formatter.timeStyle = .short
		formatter.dateFormat = "d MMMM YYYY - HH:mm:ss at "
		return formatter
	}()
	
	private let yearFormatter: DateFormatter = {
		let formatter = DateFormatter()
		formatter.dateFormat = "YYYY"
		return formatter
	}()
	
	private let intervalFormatter: DateComponentsFormatter = {
		let formatter = DateComponentsFormatter()
		formatter.allowedUnits = [.day, .hour, .minute, .second]
		formatter.zeroFormattingBehavior = .pad
		formatter.unitsStyle = .short
		return formatter
	}()
	
	func calculateAverageInterval(nuts: [Nut]) -> TimeInterval {
		
		let delta: TimeInterval = {
			if (nuts.count > 1)
			{
				var deltaTime: TimeInterval = TimeInterval()
				for i in 1..<nuts.count-1 {
					deltaTime += nuts[i].time.timeIntervalSince(nuts[i-1].time)
				}
				
				return deltaTime/Double(nuts.count)
			}
			return TimeInterval.zero
		}()
		
		return delta
	}
	
	func calculateNutsInYear(nuts: [Nut]) -> Int {
		return nuts.filter { dateFormatter.string(from: $0.time).contains(yearFormatter.string(from: nuts[nuts.count-1].time)) }.count
	}
	
	func calculateNutsPerMonth(nuts: [Nut]) -> [ChartData]
	{
		let months: [String] = ["Jan", "Feb", "Mar", "Apr",	"May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ""]
		
		var returnedNutsData: [ChartData] = []
		
		for i in 0..<12 {
			var nutCount: Int = 0
				
			for j in 0..<nuts.count {
				if dateFormatter.string(from: nuts[j].time).contains(months[i]) {
					nutCount += 1
				}
			}
			
			returnedNutsData.append(ChartData.init(timeDate: months[i], count: nutCount))
		}
		
		return returnedNutsData
	}
}

struct StatsView_Previews: PreviewProvider {
	static var previews: some View {
		StatsView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData)).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
	}
}
