//
//  ImmersiveView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
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
            let gizmo = buildSphere(0.1, .gray)
            gizmo.position = [0, 1.8, -2]
            content.add(gizmo)
            
            let gizmo2 = buildSphere(0.1, .orange)
            gizmo2.position = [1, 1.8, -2]
            content.add(gizmo2)            
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
