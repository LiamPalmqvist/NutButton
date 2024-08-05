//
//  StatsView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 04/08/2024.
//

import SwiftUI

struct StatsView: View {
	@Binding var nuts: [Nut]
	
	@State var delta: TimeInterval = TimeInterval()
	@State var nutsInYear: Int = 0
	
	var body: some View {
		VStack {
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
					delta = calculateAverageInterval(nuts: nuts)
					nutsInYear = calculateNutsInYear(nuts: nuts)
				}
			})
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
			if (nuts.count > 0)
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
}

struct StatsView_Previews: PreviewProvider {
	static var previews: some View {
		StatsView(nuts: .constant(Nut.sampleData))
	}
}
