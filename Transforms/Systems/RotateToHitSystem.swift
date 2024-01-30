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
            guard let parent = entity.parent else {return}
            
            let position = entity.position
            let entityDown = position - [0, 1, 0]
            drawLine(parent, "downLine", position, entityDown)
            let result = scene.raycast(from: position, to: entityDown)
            let floorHit = result.first(where: {$0.entity.name == "floor"})
            
            if let floorHit = floorHit {
                print("tim", floorHit.entity.name)
                let normal = floorHit.normal//entity.convert(normal: floorHit.normal, to: nil)
                drawLine(parent, "normal", position, normal)

                entity.transform.rotation *= simd_quatf(from: [0, 1, 0], to: normal)
            }
            
        }
    }
}
