//
//  OrbitView.swift
//  Transforms
//
//  Created by Timothy Huertas on 2/1/24.
//

import SwiftUI
import RealityKit

struct OrbitView: View {
    init() {
        OrbitComponent.registerComponent()
        OrbitSystem.registerSystem()
    }
    
    var body: some View {
        RealityView {
            content in
            let gizmo = BuildSphere.buildSphere(0.1, UIColor.green)
            gizmo.position = [1, 1, -2]
            content.add(gizmo)
            
            let gizmo2 = BuildSphere.buildSphere(0.1, UIColor.gray, isDraggable: false, isRotateable: false)

            gizmo2.components.set(OrbitComponent(orbits: gizmo))
            content.add(gizmo2)
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    OrbitView()
}
