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
    
    private func buildSphere(_ radius:Float, _ color:UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.components.set(DragRotateComponent())
        entity.components.set(DragTransformComponent())

        return entity
    }
    
    var body: some View {
        RealityView { content in
            let gizmo = buildSphere(0.1, .red)
            gizmo.position = [-1, 1, -2]
            gizmo.components.set(HunterHuntedComponent(isHunter: true))
            content.add(gizmo)
            
            let gizmo2 = buildSphere(0.1, .green)
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
