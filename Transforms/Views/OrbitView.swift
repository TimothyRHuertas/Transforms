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
            do {
                let gizmo = BuildSphere.buildSphere(0.1, UIColor.green)
                gizmo.position = [0, 1, -2]
                content.add(gizmo)
                
                let gizmo2 = BuildSphere.buildSphere(0.1, UIColor.gray, isDraggable: false, isRotateable: false)
                gizmo2.components.set(try OrbitComponent(orbits: gizmo, radius: 0.8))
                content.add(gizmo2)
            }
            catch {
                print("Unexpected error: \(error).")
            }
            
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    OrbitView()
}
