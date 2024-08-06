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
	
	var chartTitle: String
	var dataToDisplay: [ChartData]
	var barOrLine: Bool
	
	var body: some View {
		Text(chartTitle)
			.font(Font.custom("LEMONMILK-Regular", size: 30))
			.padding(.bottom, -25.0)
			.foregroundColor(Color("TextColor"))
		
		Chart(dataToDisplay, id: \.timeDate) { item in
			if (barOrLine)
			{
				LineMark (
					x: .value("Month", item.timeDate),
					y: .value("Count", item.count)
				)
				.foregroundStyle(Color(hex: appSettings.accent)!)
				.lineStyle(.init(lineWidth: 5))
				.interpolationMethod(.monotone)
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
