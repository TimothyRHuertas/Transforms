//
//  RotateToHitSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/30/24.
//

import RealityKit
import UIKit
import ARKit

public struct RotateToHitSystem: System {
    public static var dependencies: [SystemDependency] {
        [.after(DragRotateSystem.self), .after(DragParentSystem.self), .before(LineSystem.self)]
    }
    
    static let query = EntityQuery(where: .has(RotateToHitComponent.self))
    
    public init(scene: RealityKit.Scene) {
    }
    
    private func drawLine(_ entity:Entity, _ name:String, _ from:simd_float3, _ to:simd_float3) {
        let lineComponent = LineComponent(from: from, to: to)
        if let line = entity.findEntity(named: name) {
            line.components.set(lineComponent)
        }
        else {
            let line = ModelEntity()
            line.components.set(lineComponent)
            line.name = name
            entity.addChild(line)
        }
    }
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query)
        
        for entity in entities {
            guard let component = entity.components[RotateToHitComponent.self] else {return}
//            guard let parent = entity.parent else {return}

            let position = entity.position
//            let entityDown = position - [0, 1, 0]
//            let result = scene.raycast(from: position, to: entityDown)
            let result = scene.raycast(origin: position, direction: [0, -1, 0], relativeTo: entity.parent)

            let floorHit = result.first(where: {$0.entity.name == component.entityName})
            
            if let floorHit = floorHit {
                if(component.previousRotation == nil) {
                    entity.components[RotateToHitComponent.self]?.previousRotation = entity.transform.rotation
                }
                let normal = floorHit.normal
                entity.transform.rotation = simd_quatf(from: [0, 1, 0], to: normal)
//                drawLine(parent, "line", position, normal)
            }
            else if let previousRotation = component.previousRotation {
                entity.transform.rotation = previousRotation
                entity.components[RotateToHitComponent.self]?.previousRotation = nil
            }
            
        }
    }
}
