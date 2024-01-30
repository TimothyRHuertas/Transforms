//
//  ProximityView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/29/24.
//

import SwiftUI
import RealityKit

struct ProximityView: View {
    init() {
        ProximityToSystem.registerSystem()
        ProximityToComponent.registerComponent()
    }
    private func buildSphere(_ radius:Float, _ color:UIColor) -> ModelEntity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.components.set(DragRotateComponent())
        entity.components.set(DragTransformComponent())

        return entity
    }
    
    var body: some View {
        RealityView { content in
            let gizmo = buildSphere(0.1, UIColor.green)
            gizmo.position = [1, 2, -2]
            content.add(gizmo)
            
            let gizmo2 = buildSphere(0.1, UIColor.gray)
            gizmo2.position = [-1, 1, -3]
            content.add(gizmo2)
            
            gizmo.components.set(ProximityToComponent(entity: gizmo2))
            gizmo2.components.set(ProximityToComponent(entity: gizmo))
            
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    ProximityView()
}
