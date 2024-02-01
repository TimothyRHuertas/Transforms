//
//  DragParentSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import RealityKit

public struct DragParentSystem: System {
    static let query = EntityQuery(where: .has(DragParentComponent.self))
    public init(scene: RealityKit.Scene) {
    }

    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query).filter({ $0.components[DragParentComponent.self]?.previousGesture != nil && $0.components[DragParentComponent.self]?.currentGesture != nil && $0.parent != nil})

        for entity in entities {
            if let component = entity.components[DragParentComponent.self], let previousGesture = component.previousGesture,  let currentGesture = component.currentGesture, let parent = entity.parent {
                let previousLocation = previousGesture.convert(previousGesture.location3D, from: .global, to: .scene)
                
                let currentLocation = currentGesture.convert(currentGesture.location3D, from: .global, to: .scene)
                
                let delta = currentLocation - previousLocation
                let lengthOfDrag = distance(currentLocation, previousLocation)
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
                
                // Leaving this way so I can debug later
                if let difference = difference {
                    let deltaDotDifference = dot(normalize(delta), normalize(difference))
                    let axisMultiplier:Float =  deltaDotDifference  < 0 ? -1 : 1
                    parent.position += difference * lengthOfDrag * 6 * axisMultiplier
                    entity.components[DragParentComponent.self]?.previousGesture = nil
                    entity.components[DragParentComponent.self]?.currentGesture = nil
                }
                
            }
            
        }
    }
}

