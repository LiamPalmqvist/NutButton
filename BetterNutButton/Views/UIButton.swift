//
//  UIButton.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 03/08/2024.
//
import SwiftUI

struct UIButton: View {
	
	@State private var isAnimating = false;
	@State private var scale = 10
	
	
	private var _action: () -> Void
	private var _bodyText: String
	private var _backgroundColor: Color
	
	var action: () -> Void {
		return _action
	}
	
	var bodyText: String! {
		return _bodyText
	}
	
	var backgroundColor: Color! {
		return _backgroundColor
	}
	
	init(action: @escaping () -> Void, bodyText: String!, backgroundColor: Color!) {

		self._bodyText = bodyText
		self._backgroundColor = backgroundColor
		self._action = action
	}
	
	var body: some View {
		
		ZStack {
			RoundedRectangle(cornerSize: CGSize(width:30, height:30))
				.foregroundColor(backgroundColor)
				.frame(width: 315 + CGFloat(scale), height: 60 + CGFloat(scale))
			
			
			
			Text(bodyText)
				.font(Font.custom("LEMONMILK-Regular", size: 35))
				.frame(width: 350 + CGFloat(scale))
				.foregroundColor(Color(.white))
		}
		.frame(width: 360, height: 80)
		.onTapGesture {
			action()
		}
		.onLongPressGesture(minimumDuration: 100, maximumDistance: CGFloat(360)) {
		} onPressingChanged: { inProgress in
			isAnimating.toggle()
			switch isAnimating
			{
			case true:
				print("held")
				withAnimation(.easeIn(duration: 0.1)) {
					scale = 0
				}
				break;
			case false:
				print("let go")
				withAnimation(.interpolatingSpring(duration: 0.1, bounce: 0.5, initialVelocity: 10))
				{
					scale = 10
				}
				break;
			}
		}
		
	}
}

struct UIButton_Previews: PreviewProvider {
	static var previews: some View {
		UIButton(action: {print("Hello")}, bodyText: "Preview", backgroundColor: Color("BackgroundColor")).preferredColorScheme(.dark)
		UIButton(action: {}, bodyText: "Preview", backgroundColor: Color("BackgroundColor")).preferredColorScheme(.light)
	}
}
