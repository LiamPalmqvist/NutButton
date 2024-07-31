//
//  MainButtonView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//


import SwiftUI

struct MainButtonView: View {
	@State private var newNut = Nut.newNut
	@Binding var nuts: [Nut]
	@State private var scale = 290.0
	@State private var isAnimating = false;
	
	var body: some View {
		Button {
			nuts.append(newNut)
		} label: {
			ZStack {
				Circle()
					.fill(Color("BigButtonColor"))
					.padding(.all)
				Image("chestnut")
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: scale, height: scale)
			}
		}
		.onLongPressGesture(minimumDuration: 0)
		{
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
		MainButtonView(nuts: .constant(Nut.sampleData))
	}
}
