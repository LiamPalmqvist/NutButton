//
//  ListItem.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 01/08/2024.
//

import SwiftUI

struct ListItem: View {
	@Binding var parsedDate: Date
	@Binding var assocNut: Int
	@Binding var nuts: [Nut]
	
	private let dateFormatter: DateFormatter = {
		let formatter = DateFormatter()
		//formatter.dateStyle = .long
		//formatter.timeStyle = .short
		formatter.dateFormat = "d MMMM YYYY - HH:mm:ss at "
		return formatter
	}()
	
	var body: some View {
		ZStack {
			Rectangle()
				.foregroundColor(Color("ContainerColor"))
				.frame(width: 375, height: 100)
				.cornerRadius(15)
			
			HStack {
				VStack {
					if (Calendar.current.isDateInToday(parsedDate))
					{
						HStack {
							Text("TODAY")
								.font(Font
									.custom("LEMONMILK-Regular", size: 35))
								.multilineTextAlignment(.leading)
								.foregroundColor(Color("TextColor"))
							Spacer()
						}
							
					} else if (Calendar.current.isDateInYesterday(parsedDate))
					{
						HStack {
							Text("YESTERDAY")
								.font(Font
									.custom("LEMONMILK-Regular", size: 35))
								.multilineTextAlignment(.leading)
								.foregroundColor(Color("TextColor"))
							Spacer()
						}
					} else {
						HStack {
							Text(formatDate(format: "d MMMM", date: parsedDate))
								.font(Font.custom("LEMONMILK-Regular", size:35))
								.multilineTextAlignment(.leading)
								.frame(alignment: .leading)
								.foregroundColor(Color("TextColor"))
							Spacer()
						}
					}
					HStack {
						Text(formatDate(format: "HH:mm:ss", date: parsedDate))
							.font(Font.custom("LEMONMILK-Regular", size:20))
							.foregroundColor(Color("TextColor"))
						Spacer()
					}
					
					
				}
				.padding(.leading, 30)
				
				Spacer()
				
				ZStack {
					Circle()
						.frame(width: 50)
						.foregroundColor(Color("accentRed"))
					Image(systemName: "plus")
						.font(.largeTitle.weight(.bold))
						.rotationEffect(.degrees(45))
						.foregroundColor(Color.white)
				}
				.onTapGesture {
					delete(at: assocNut)
				}
				.padding(.trailing, 30)
				
				
			}
		}
	}
	
	private func formatDate(format: String, date: Date) -> String
	{
		dateFormatter.dateFormat = format
		let returnString = dateFormatter.string(from: date)
		dateFormatter.dateFormat = "d MMMM YYYY - HH:mm:ss"
		return returnString
	}
	
	
	func delete(at offsets: Int)
	{
		nuts.remove(at: offsets)
	}
	
}

struct ListItem_Previews: PreviewProvider {
	static var previews: some View {
		ListItem(parsedDate: .constant(Date.now), assocNut: .constant(0), nuts: .constant(Nut.sampleData))
			.preferredColorScheme(.dark)
		ListItem(parsedDate: .constant(Date.now), assocNut: .constant(0), nuts: .constant(Nut.sampleData))
			.preferredColorScheme(.light)
	}
}
