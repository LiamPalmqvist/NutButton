//
//  MainButtonView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//


import SwiftUI

struct MainButtonView: View {
	@State private var scale = 290.0
	@State private var isAnimating = false
	
	private var _width: Float
	private var _action: () -> Void
	
	var action: () -> Void {
		return _action
	}
	
	var width: Float {
		return _width
	}
	
	init(action: @escaping () -> Void, width: Float) {
		self._action = action
		self._width = width
	}
	
	var body: some View {
		
		ZStack {
			Circle()
				.fill(Color("BigButtonColor"))
				.padding(.all)
				.frame(width: CGFloat(width)*400)
			Image("chestnut")
				.resizable()
				.aspectRatio(contentMode: .fit)
				.frame(width: Double(width)*scale, height: Double(width)*scale)
		}
		.onTapGesture {
			action()
		}
		.onLongPressGesture(minimumDuration: 100, maximumDistance: CGFloat(290)) {
		} onPressingChanged: { inProgress in
			isAnimating.toggle()
			switch isAnimating
			{
			case true:
				print("held")
				withAnimation(.easeIn(duration: 1.5)) {
					scale = 0
				}
				break;
			case false:
				print("let go")
				withAnimation(.interpolatingSpring(duration: 0.1, bounce: 0.5, initialVelocity: 10))
				{
					scale = 290
				}
				break;
			}
		}
		
	}
}

struct MainButtonView_Previews: PreviewProvider {
	static var previews: some View {
		MainButtonView(action: {}, width: 1).preferredColorScheme(.dark)
		MainButtonView(action: {}, width: 1).preferredColorScheme(.light)
	}
}
