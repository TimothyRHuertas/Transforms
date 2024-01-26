//
//  TransformsApp.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import SwiftUI

@main
struct TransformsApp: App {
    init() {
        DragRotateComponent.registerComponent()
        DragRotateSystem.registerSystem()
        
        DragParentComponent.registerComponent()
        DragParentSystem.registerSystem()
        
        DragTransformComponent.registerComponent()
        DragTransformSystem.registerSystem()
    }
    
    var body: some Scene {
        WindowGroup(id: "ContentView") {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
