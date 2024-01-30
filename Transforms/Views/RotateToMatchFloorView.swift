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
            entity.position = [0, 2.0, -2]
            entity.components.set(DragTransformComponent())
            
            var dragRotateComponent = DragRotateComponent()
            dragRotateComponent.rotateY = false
            entity.components.set(dragRotateComponent)
            content.add(entity)
        }
        .dragParent()
        .dragRotation()
    }
}

#Preview {
    RotateToMatchFloorView()
}
