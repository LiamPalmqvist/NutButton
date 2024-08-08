//
//  ContentView.swift
//  BetterNutButton
//
//  Created by Liam Palmqvist on 31/07/2024.
//

import SwiftUI

struct ContentView: View {

	@Binding var nuts: [Nut]
	@Binding var appSettings: AppSettings
	@Binding var settingsManager: SettingsManager
	@State var isPresentingHistory: Bool = false
	@Environment(\.scenePhase) private var scenePhase
	let saveAction: ()-> Void
	
	var body: some View {
		GeometryReader {proxy in
			ZStack {
				Color("BackgroundColor")
					.ignoresSafeArea()
				
				VStack {
					HStack {
						
						Spacer()
						
						HamburgerMenuButton(nuts: $nuts, appSettings: $appSettings, settingsManager: $settingsManager)
							.padding(.trailing, 30)
					}
					
					MainButtonView(action: {nuts.append(Nut(time:Date.now))}, width: 0.9)
						.padding(.top, -50)
						.fixedSize()
					Spacer()
					Button(action: {
						isPresentingHistory = true
					}, label: {
						VStack {
							Text("NUTS")
								.font(
									.custom("LEMONMILK-Regular", size: 70))
								.foregroundColor(Color("TextColor"))
								.padding(.bottom, -10)
								
							Text(String(nuts.count))
								.font(.custom("LEMONMILK-regular", size: 70))
								.fontWeight(.bold)
								.padding(.vertical, 5)
								.padding(.horizontal)
								.padding(.horizontal)
								.background(Color("ContainerColor"))
								.foregroundColor(Color("TextColor"))
								.cornerRadius(90)
						}
					})
					.sheet(isPresented: $isPresentingHistory) {
						HistoryView(nuts: $nuts, appSettings: $appSettings)
					}
					
					
					Spacer()

				}
				.onChange(of: scenePhase) {
					if (scenePhase == .inactive) { saveAction() }
				}.onAppear {
					requestOrientations(.portrait) // request initial portrait orientation
					AppDelegate.orientationLock = .portrait // set it for good
				}
			}
		}
	}
	
	private func requestOrientations(_ orientations: UIInterfaceOrientationMask) {
		if #available(iOS 16.0, *) {
			if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
				scene.requestGeometryUpdate(.iOS(interfaceOrientations: orientations)) { error in
					// Handle denial of request.
				}
			}
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
		ContentView(nuts: .constant(Nut.sampleData), appSettings: .constant(AppSettings.sampleData), settingsManager: .constant(SettingsManager()), saveAction: {} ).preferredColorScheme(.dark)
	}
}
