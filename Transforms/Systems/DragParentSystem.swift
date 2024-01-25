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
                let matrixCols = parent.transformMatrix(relativeTo: nil).columns
                // This also works
                // let difference =  normalize(entity.position(relativeTo: nil) - parent.position(relativeTo: nil))
                // but I want o make sure I'm using the transforms
                let difference:simd_float3? = switch component.axis {
                    case .x: simd_make_float3(matrixCols.0)
                    case .y: simd_make_float3(matrixCols.1)
                    case .z: simd_make_float3(matrixCols.2)
                    default:nil
                }
                
                if let difference = difference {
                    let deltaSum = Float(normalize(delta).sum())
                    let diffrenceSum = difference.sum()
                    let deltaDifferenceProduct = diffrenceSum * deltaSum
                    let axisMultiplier:Float = (deltaDifferenceProduct > 0) ? 1 : -1
                    parent.position += difference * sensitivity * axisMultiplier
                    entity.components[DragParentComponent.self]?.delta = nil
                }
                
            }
            
        }
    }
}

