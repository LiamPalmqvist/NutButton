//
//  CalendarView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 05/08/2024.
//

import SwiftUI

struct CalendarView: View {
	@Binding var nuts: [Nut]
	@Binding var appSettings: AppSettings
	@Binding var showingCalendar: Bool
	@State private var selectedDate: Date = Date()
	
	var body: some View {
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			VStack {
				DatePicker(selection: $selectedDate, in: ...Date.now, displayedComponents: [.date, .hourAndMinute]) {
					Text("Select a date")
				}.datePickerStyle(.graphical)
					.frame(height: 500)
					.frame(maxWidth: .infinity)
				
				UIButton(action: {nuts.append(Nut(time: selectedDate)); showingCalendar = false; setNuts()}, bodyText: "Add nut", backgroundColor: Color(hex: appSettings.accent))
			
				Spacer()
			}
		}
	}
	
	func returnNuts(nuts: [Nut]) async throws -> [Nut] {
		let task = Task {
			return nuts.sorted { ($0.time as Date) < ($1.time as Date) }
		}
		return await task.value
	}
	
	func setNuts() {
		Task {
			self.nuts = try await returnNuts(nuts: nuts)
		}
	}
}

struct CalendarView_Preview: PreviewProvider {
	static var previews: some View {
		CalendarView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData), showingCalendar: .constant(true)).preferredColorScheme(.dark)
	}
}
