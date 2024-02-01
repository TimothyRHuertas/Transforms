//
//  LineOfSightView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/27/24.
//

import SwiftUI
import RealityKit

struct HunterHuntedView: View {
    
    init() {
        HunterHuntedSystem.registerSystem()
        HunterHuntedComponent.registerComponent()
    }
    
    var body: some View {
        RealityView { content in
            let gizmo = BuildSphere.buildSphere(0.1, .red)
            gizmo.position = [-1, 1, -2]
            gizmo.components.set(HunterHuntedComponent(isHunter: true))
            content.add(gizmo)
            
            let gizmo2 = BuildSphere.buildSphere(0.1, .green)
            gizmo2.position = [1, 1, -2]
            gizmo2.components.set(HunterHuntedComponent(isHunter: false))
            content.add(gizmo2)
            
            
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    HunterHuntedView()
}
