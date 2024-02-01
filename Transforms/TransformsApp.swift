//
//  TransformsApp.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import SwiftUI

@main
struct TransformsApp: App {
    @Bindable private var viewModel = ViewModel()
    init() {
        DragRotateComponent.registerComponent()
        DragRotateSystem.registerSystem()
        
        DragParentComponent.registerComponent()
        DragParentSystem.registerSystem()
        
        DragTransformComponent.registerComponent()
        DragTransformSystem.registerSystem()
        
        LineComponent.registerComponent()
        LineSystem.registerSystem()
    }
    
    var body: some Scene {
        WindowGroup(id: "ContentView") {
            ContentView()
        }
        
        ImmersiveSpace(id: "ImmersiveSpace") {
            NavigationView().environment(viewModel)
            
            switch viewModel.currentView {
            case .position:
                PositionView()
            case .chase:
                HunterHuntedView()
            case .connect:
                ConnectView()
            case .proximity:
                ProximityView()
            case .rotateToMatchFloor:
                RotateToMatchFloorView()
            case .orbit:
                OrbitView()
            }
        }
    }
}
