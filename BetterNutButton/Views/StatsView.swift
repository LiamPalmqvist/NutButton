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

extension ChartData {
	static let SampleData: [ChartData] =
		[
		 ChartData.init(timeDate: "Jan", count: 22),
		 ChartData.init(timeDate: "Feb", count: 14),
		 ChartData.init(timeDate: "Mar", count: 22),
		 ChartData.init(timeDate: "Apr", count: 32),
		 ChartData.init(timeDate: "May", count: 13),
		 ChartData.init(timeDate: "Jun", count: 27),
		 ChartData.init(timeDate: "Jul", count: 22),
		 ChartData.init(timeDate: "Aug", count: 22),
		 ChartData.init(timeDate: "Sep", count: 14),
		 ChartData.init(timeDate: "Oct", count: 17),
		 ChartData.init(timeDate: "Nov", count: 34),
		 ChartData.init(timeDate: "Dec", count: 22),
		]
	
}

struct StatsView: View {
	@Binding var nuts: [Nut]
	@Binding var appSettings: AppSettings
	
	@State var delta: TimeInterval = TimeInterval()
	@State var nutsInYear: Int = 0
	@State var timesPerMonthData: [ChartData] = []
	@State var timesPerHourData: [ChartData] = []
	
	var body: some View {
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			
			ScrollView {
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
					.onAppear(perform: {
						Task {
							delta = calculateAverageInterval(nuts: nuts)
							nutsInYear = calculateNutsInYear(nuts: nuts)
						}
					})
					
					Text("nuts in \(yearFormatter.string(from: Date.now))")
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
								.font(Font.custom("LEMONMILK-Regular", size: 30))
								.foregroundColor(Color("TextColor"))
						}
					}
					.onAppear(perform: {
						Task {
							if (nuts.count > 1) {
								delta = calculateAverageInterval(nuts: nuts)
								nutsInYear = calculateNutsInYear(nuts: nuts)
								timesPerMonthData = calculateNutsPerMonth(nuts: nuts, calculateMonthsOrHours: true)
								timesPerHourData = calculateNutsPerMonth(nuts: nuts, calculateMonthsOrHours: false)
							}
							
							print(timesPerMonthData)
						}
					})
					
					if (nuts.count > 0) {
						// Average nuts per month
						StatsChart(appSettings: $appSettings, chartTitle: "Nuts per month", data: timesPerMonthData, barOrLine: true).padding(.bottom, 50)
						StatsChart(appSettings: $appSettings, chartTitle: "average time", data: timesPerHourData, barOrLine: false)
					}
					
					Spacer()
				}
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
		return nuts.filter { dateFormatter.string(from: $0.time).contains(yearFormatter.string(from: Date.now)) }.count
	}
	
	func calculateNutsPerMonth(nuts: [Nut], calculateMonthsOrHours: Bool) -> [ChartData]
	{
		let months: [String] = ["Jan", "Feb", "Mar", "Apr",	"May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec", ""]
		let hours: [String] = [" 00:", " 01:", " 02:", " 03:",	" 04:", " 05:", " 06:", " 07:", " 08:", " 09:", " 10:", " 11:", " 12: ", " 13:", " 14:", " 15:", " 16:", " 17:", " 18:", " 19:", " 20:", " 21:", " 22:", " 23:", ""]
		
		var returnedNutsData: [ChartData] = []
		
		if calculateMonthsOrHours {
			for i in 0..<12 {
				var nutCount: Int = 0
					
				for j in 0..<nuts.count {
					if dateFormatter.string(from: nuts[j].time).contains(months[i]) && dateFormatter.string(from:nuts[j].time).contains(yearFormatter.string(from: nuts.last!.time)) {
						nutCount += 1
					}
				}
				
				returnedNutsData.append(ChartData.init(timeDate: months[i], count: nutCount))
			}
		} else {
			for i in 0..<24 {
				var nutCount: Int = 0
					
				for j in 0..<nuts.count {
					if dateFormatter.string(from: nuts[j].time).contains(hours[i]) {
						nutCount += 1
					}
				}
				
				if (hours[i][1] == "0") {
					
					let tempString = hours[i][2]
					returnedNutsData.append(ChartData.init(timeDate: String(tempString), count: nutCount))
				} else {
					returnedNutsData.append(ChartData.init(timeDate: hours[i].replacingOccurrences(of: ":", with: "").replacingOccurrences(of: " ", with: ""), count: nutCount))
				}
			}
		}
		
		return returnedNutsData
	}

}

struct StatsView_Previews: PreviewProvider {
	static var previews: some View {
		StatsView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData)).preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
	}
}
