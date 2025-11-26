//
//  ColorChangeDemoAppApp.swift
//  ColorChangeDemoApp
//
//  Created by luminous on 26/11/25.
//

import SwiftUI

@main
struct ColorChangeDemoAppApp: App {
    private let dependencyContainer = DependencyContainer()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                Color.white
                    .ignoresSafeArea(.all)
                
                ColorTogglingView(viewModel: dependencyContainer.makeColorTogglingViewModel())
            }
            .preferredColorScheme(.light)
            .onAppear {
                // Set window background to white using UIKit
                DispatchQueue.main.async {
                    if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                        windowScene.windows.forEach { window in
                            window.backgroundColor = .white
                        }
                    }
                }
            }
        }
    }
}
