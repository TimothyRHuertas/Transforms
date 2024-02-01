//
//  BuildSphere.swift
//  Transforms
//
//  Created by Timothy Huertas on 2/1/24.
//
import RealityKit
import UIKit

struct BuildSphere {
    static func buildSphere(_ radius:Float, _ color:UIColor, isDraggable:Bool = true, isRotateable:Bool = true) -> ModelEntity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        if isRotateable { entity.components.set(DragRotateComponent()) }
        if isDraggable { entity.components.set(DragTransformComponent()) }
        if isDraggable || isRotateable { entity.components.set(CollisionComponent(shapes: [ShapeResource.generateSphere(radius: radius)])) }

        return entity
    }
}
