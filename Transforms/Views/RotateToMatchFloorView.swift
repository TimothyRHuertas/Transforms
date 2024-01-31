//
//  RotateToMatchFloot.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/30/24.
//

import SwiftUI
import RealityKit

struct RotateToMatchFloorView: View {
    
    init() {
        RotateToHitSystem.registerSystem()
        RotateToHitComponent.registerComponent()
    }
    
    var body: some View {
        RealityView {
            content in
            
            let material = SimpleMaterial.init(color: .red, isMetallic: true)
            let boxSize:Float = 0.3
            let mesh = MeshResource.generateBox(size: boxSize)
            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.position = [1, 0.5, -3]
            entity.components.set(DragTransformComponent())
            entity.components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: mesh.bounds.extents)]))
            content.add(entity)
            
            let hillMaterial = SimpleMaterial.init(color: .gray, isMetallic: true)
            let meshDepth:Float = 1.0
            let meshWidth:Float = 3.0
            let hillMesh = MeshResource.generateBox(width: meshWidth, height: 0.001, depth: meshDepth)
            let hillEntity = ModelEntity(mesh: hillMesh, materials: [hillMaterial])
            hillEntity.position = [-meshWidth/2, 0, 0]
            let hillParent = ModelEntity()
            hillParent.addChild(hillEntity)
            hillParent.position = [0, 0, -3]
            hillParent.transform.rotation = simd_quatf(.init(angle: .degrees(-45), axis: .z))
            hillEntity.name = "floor"
            if !hillEntity.components.has(CollisionComponent.self) {
                hillEntity.generateCollisionShapes(recursive: true)
                hillEntity.components.set(CollisionComponent(shapes: [ShapeResource.generateBox(size: hillMesh.bounds.extents)]))
            }
            entity.components.set(RotateToHitComponent(entityName: hillEntity.name))

            content.add(hillParent)
        }
        .dragParent()
    }
}

#Preview {
    RotateToMatchFloorView()
}
