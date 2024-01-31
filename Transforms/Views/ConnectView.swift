//
//  ConnectView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/26/24.
//

import SwiftUI
import RealityKit

struct ConnectView: View {
    private func buildSphere(_ radius:Float, _ color:UIColor) -> ModelEntity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.components.set(DragRotateComponent())
        entity.components.set(DragTransformComponent())
        entity.components.set(CollisionComponent(shapes: [ShapeResource.generateSphere(radius: radius)]))

        return entity
    }
    
    var body: some View {
        RealityView { content in
            let gizmo = buildSphere(0.1, .gray)
            gizmo.position = [1, 2, -2]
            content.add(gizmo)
            
            let gizmo2 = buildSphere(0.1, .gray)
            gizmo2.position = [-1, 1, -3]
            content.add(gizmo2)
            
            gizmo.components.set(ConnectToComponent(entity: gizmo2))            
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    ConnectView()
}
