//
//  DragTransformSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/26/24.
//
import RealityKit
import UIKit

public struct DragTransformSystem: System {
    static let query = EntityQuery(where: .has(DragTransformComponent.self))
    
    public init(scene: RealityKit.Scene) {
    }
    
    private func buildCylinder(_ height:Float, _ color: UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateCylinder(height: height, radius: 0.02)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        makeDragable(entity)
        
        return entity
    }
    
    private func buildSphere(_ radius:Float, _ color:UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        makeDragable(entity)
        entity.components.set(DragRotateComponent())

        return entity
    }
        
    private func makeDragable(_ entity:ModelEntity) {
        if !entity.components.has(InputTargetComponent.self) {
            entity.components.set(InputTargetComponent())
        }
           
        if !entity.components.has(CollisionComponent.self) {
            entity.generateCollisionShapes(recursive: true)
            entity.components.set(CollisionComponent(shapes: entity.collision!.shapes))
        }
}
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query).filter({$0.components[DragTransformComponent.self]?.shouldInit == true})
        let lineLength:Float = 0.5
        let lineOffset:Float = lineLength/2
        
        for entity in entities {
            entity.components[DragTransformComponent.self]?.shouldInit = false

            let modelEntity = entity as! ModelEntity
            makeDragable(modelEntity)
            
            let lineX = buildCylinder(lineLength, .red)
            lineX.position.x = lineOffset
            lineX.transform.rotation = simd_quatf(.init(angle: .degrees(90.0), axis: .z))
            lineX.components[DragParentComponent.self] = DragParentComponent(axis: .x)
            modelEntity.addChild(lineX)
            
            let lineY = buildCylinder(lineLength, .green)
            lineY.position.y = lineOffset
            lineY.components[DragParentComponent.self] = DragParentComponent(axis: .y)
            modelEntity.addChild(lineY)
            
            let lineZ = buildCylinder(lineLength, .blue)
            lineZ.position.z = lineOffset
            lineZ.transform.rotation = simd_quatf(.init(angle: .degrees(90.0), axis: .x))
            lineZ.components[DragParentComponent.self] = DragParentComponent(axis: .z)

            modelEntity.addChild(lineZ)
        }
    }
}
