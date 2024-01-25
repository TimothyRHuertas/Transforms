//
//  DragParentSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import RealityKit


public struct DragParentSystem: System {
    static let query = EntityQuery(where: .has(DragParentComponent.self))
    let sensitivity:Float =  0.05
    
    public init(scene: RealityKit.Scene) {
    }
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query).filter({$0.components[DragParentComponent.self]?.delta != nil && $0.parent != nil})

        for entity in entities {
            if let component = entity.components[DragParentComponent.self], let delta = component.delta, let parent = entity.parent {
                let difference =  normalize(entity.position(relativeTo: nil) - parent.position(relativeTo: nil))
                let deltaSum = Float(normalize(delta).sum())
                let diffrenceSum = difference.sum()
                let deltaDifferenceProduct = diffrenceSum * deltaSum
                
                var axisMultiplier:Float = 1.0
                
                print(deltaDifferenceProduct)
                if(component.axis == .y) {
                    if(deltaDifferenceProduct > 0) {
                        axisMultiplier = -1.0
                    }
                }
                else if(deltaDifferenceProduct < 0) {
                    axisMultiplier = -1.0
                }
                
                parent.position += difference * sensitivity * axisMultiplier
                entity.components[DragParentComponent.self]?.delta = nil
            }
            
        }
    }
}

