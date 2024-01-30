//
//  RotateToMatchFloot.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/30/24.
//

import SwiftUI
import RealityKit

struct RotateToMatchFloorView: View {
    var body: some View {
        RealityView {
            content in
            
            let material = SimpleMaterial.init(color: .gray, isMetallic: true)
            let mesh = MeshResource.generateBox(size: 0.2)
            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.position = [1, 2.0, -2]
            entity.components.set(DragTransformComponent())
            entity.transform.rotation = simd_quatf(.init(angle: .degrees(-90), axis: .y))
            var dragRotateComponent = DragRotateComponent()
            dragRotateComponent.rotateX = false
            entity.components.set(dragRotateComponent)
            content.add(entity)
            
            let hillMaterial = SimpleMaterial.init(color: .gray, isMetallic: true)
            let hillMesh = MeshResource.generateSphere(radius: 0.8)
            let hillEntity = ModelEntity(mesh: hillMesh, materials: [hillMaterial])
            hillEntity.position = [-1, 2.0, -2]
            content.add(hillEntity)
        }
        .dragParent()
        .dragRotation()
    }
}

#Preview {
    RotateToMatchFloorView()
}
