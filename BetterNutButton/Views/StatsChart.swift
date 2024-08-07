//
//  StatsChart.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 06/08/2024.
//

import SwiftUI
import Charts

struct StatsChart: View {
	
	@Binding var appSettings: AppSettings
	
	@State var showSelectionBar: Bool = false
	@State private var offsetX = 0.0
	@State private var offsetY = 0.0
	@State private var selectedDay = ""
	@State private var selectedMins = 0
	
	var chartTitle: String
	var data: [ChartData]
	var barOrLine: Bool
	
	var body: some View {
		Text(chartTitle)
			.font(Font.custom("LEMONMILK-Regular", size: 30))
			.padding(.bottom, -25.0)
			.foregroundColor(Color("TextColor"))
		
		Chart(data, id: \.timeDate) { item in
			if (barOrLine)
			{
				LineMark (
					x: .value("Month", item.timeDate),
					y: .value("Count", item.count)
				)
				.foregroundStyle(Color(hex: appSettings.accent)!)
				.lineStyle(.init(lineWidth: 5))
				.interpolationMethod(.monotone)
				.symbol(.circle)
				.symbolSize(200)
				
			} else {
				BarMark (
					x: .value("Month", item.timeDate),
					y: .value("Count", item.count)
				)
				.foregroundStyle(Color(hex: appSettings.accent)!)
				.lineStyle(.init(lineWidth: 5))
				.interpolationMethod(.monotone)
			}

		}
		.chartOverlay { pr in
			if (barOrLine) {
				GeometryReader { geoProxy in
					Rectangle().foregroundStyle(Color(hex: appSettings.accent)!)
						.frame(width: 4, height: geoProxy.size.height * 0.95)
						.opacity(showSelectionBar ? 1.0 : 0.0)
						.offset(x: offsetX)
					
					Circle()
						.foregroundColor(.clear)
						.frame(width: 50, height: 30)
						.overlay {
							Text("\(selectedMins)")
								.font(Font.custom("LEMONMILK-Regular", size: 30))
								.foregroundColor(Color(hex: appSettings.accent))
						}
						.opacity(showSelectionBar ? 1.0 : 0.0)
						.offset(x: offsetX - 23.5, y: offsetY - 40)
					
					Rectangle().fill(.clear).contentShape(Rectangle())
						.gesture(DragGesture().onChanged { value in
							if !showSelectionBar {
								showSelectionBar = true
							}
							let origin = geoProxy[pr.plotFrame!].origin
							let location = CGPoint(
								x: value.location.x - origin.x,
								y: value.location.y - origin.y
							)
							offsetX = location.x
							
							
							let (day, _) = pr.value(at: location, as: (String, Int).self) ?? ("-", 0)
							let mins = data.first { w in
								w.timeDate == day
							}?.count ?? 0
							selectedDay = day
							selectedMins = mins
						}
							.onEnded( { _ in
								showSelectionBar = false
							})
						)
				}
			}
		}
		
		.chartPlotStyle(content: { plotArea in
			plotArea
				.background(Color.clear)
		})
		
		.chartYAxis() {
			AxisMarks(position: .leading) {
				AxisValueLabel().font(Font.custom("LEMONMILK-Regular", size: 12))
				AxisGridLine().foregroundStyle(.clear)
			}
		}
		.chartXAxis() {
			AxisMarks(position: .bottom) {
				if (barOrLine)
				{
					AxisValueLabel().font(Font.custom("LEMONMILK-Regular", size: 12))
				} else {
					AxisValueLabel().font(Font.custom("LEMONMILK-Regular", size: 9))
				}
				AxisGridLine().foregroundStyle(.clear)
			}
		}.frame(width: 390, height: 390)
	}
}

struct StatsChart_Previews: PreviewProvider {
	static var previews: some View {
		StatsChart(appSettings: .constant(AppSettings.sampleData), chartTitle: "Title", data: ChartData.SampleData, barOrLine: true)
	}
}
