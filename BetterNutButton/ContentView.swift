//
//  ContentView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import SwiftUI

struct ContentView: View {

	@Binding var nuts: [Nut]
	@Environment(\.scenePhase) private var scenePhase
	let saveAction: ()-> Void
	
	var body: some View {
		ZStack {
			Color("BackgroundColor")
				.ignoresSafeArea()
			
			VStack {
				HStack {
					Spacer()
					SettingsButton()
						.padding(.trailing, 20)
				}
				Spacer()
				MainButtonView(nuts: $nuts)
				Text("NUTS")
					.font(Font
						.custom("LEMONMILK-Regular", size: 56))
					.foregroundColor(Color("TextColor"))
				NutCountButtonView(nuts: $nuts)
				Spacer()
				Spacer()
			}
			.onChange(of: scenePhase) {
				if (scenePhase == .inactive) { saveAction() }
			}
		}.onAppear {
			UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation") // Forcing the rotation to portrait
			AppDelegate.orientationLock = .portrait // And making sure it stays that way
		}
		
	}
		
}

class AppDelegate: NSObject, UIApplicationDelegate {
		
	static var orientationLock = UIInterfaceOrientationMask.all

	func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
		return AppDelegate.orientationLock
	}
}

struct ContentView_Previews: PreviewProvider {
	// need to provide a constant for the data
	static var previews: some View {
		ContentView(nuts: .constant(Nut.sampleData), saveAction: {}).preferredColorScheme(.dark)
		ContentView(nuts: .constant(Nut.sampleData), saveAction: {}).preferredColorScheme(.light)
	}
}
