//
//  TransformsApp.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import SwiftUI

@main
struct TransformsApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
