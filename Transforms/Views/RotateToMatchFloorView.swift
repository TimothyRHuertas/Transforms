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
    
    private func makeCollidable(_ entity:ModelEntity) {
        if !entity.components.has(CollisionComponent.self) {
            entity.generateCollisionShapes(recursive: true)
            entity.components.set(CollisionComponent(shapes: entity.collision!.shapes))
        }
    }
    
    var body: some View {
        RealityView {
            content in
            
            let material = SimpleMaterial.init(color: .red, isMetallic: true)
            let mesh = MeshResource.generateBox(size: 0.5)
            let entity = ModelEntity(mesh: mesh, materials: [material])
            entity.position = [1, 1, -2]
            entity.components.set(DragTransformComponent())
            content.add(entity)
            
            let hillMaterial = SimpleMaterial.init(color: .gray, isMetallic: true)
            let meshDepth:Float = 4.0
            let meshWidth:Float = 4.0
            let hillMesh = MeshResource.generateBox(width: meshWidth, height: 0.001, depth: meshDepth)
            let hillEntity = ModelEntity(mesh: hillMesh, materials: [hillMaterial])
            hillEntity.position = [-meshWidth/2, 0, 0]
            let hillParent = ModelEntity()
            hillParent.addChild(hillEntity)
            hillParent.position = [0, 0, -2]
            hillParent.transform.rotation = simd_quatf(.init(angle: .degrees(-45), axis: .z))
            hillEntity.name = "floor"
            makeCollidable(hillEntity)
            entity.components.set(RotateToHitComponent(entityName: hillEntity.name))

            content.add(hillParent)
        }
        .dragParent()
    }
}

#Preview {
    RotateToMatchFloorView()
}
