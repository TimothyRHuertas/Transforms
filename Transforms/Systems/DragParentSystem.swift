//
//  DragParentSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import RealityKit


public struct DragParentSystem: System {
    static let query = EntityQuery(where: .has(DragParentComponent.self))
    let sensitivity:Float =  0.001
    
    public init(scene: RealityKit.Scene) {
    }
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query).filter({$0.components[DragParentComponent.self]?.delta != nil && $0.parent != nil})

        for entity in entities {
            if let component = entity.components[DragParentComponent.self], let delta = component.delta, let parent = entity.parent {
                let difference =  entity.position(relativeTo: nil) - parent.position(relativeTo: nil)
                let deltaSum = component.axis == .y ? -delta.vector.sum() : delta.vector.sum()
                
                print(difference.sum(), delta.vector.sum())
                
                if(deltaSum > 0) {
                    parent.position += difference * 0.1
                }
                else  {
                    parent.position -= difference * 0.1
                }

                entity.components[DragParentComponent.self]?.delta = nil
            }
            
        }
    }
}

