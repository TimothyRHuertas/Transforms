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
                
                switch component.axis {
                    case .x:
                    parent.position.x += Float(delta.x) * sensitivity
                        break
                    case .y:
                    parent.position.y -= Float(delta.y) * sensitivity
                        break
                    case .z:
                    parent.position.z += Float(delta.y) * sensitivity
                        break
                    default:
                        print("oops")
                }
                
                                
                entity.components[DragParentComponent.self]?.delta = nil
            }
            
        }
    }
}

