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
        let entities = scene.performQuery(Self.query).filter({$0.components[DragParentComponent.self]?.dragGesture != nil && $0.parent != nil})

        for entity in entities {
            if let component = entity.components[DragParentComponent.self], let dragGesture = component.dragGesture, let parent = entity.parent {
                
                let newLocation3D = dragGesture.convert(dragGesture.location3D, from: .local, to: .scene)
                let existingLocation3D = entity.position(relativeTo: nil)
                let delta = newLocation3D - existingLocation3D
                
                switch component.axis {
                    case .x:
                        parent.position.x += delta.x
                        break
                    case .y:
                        parent.position.y += delta.y
                        break
                    case .z:
                        parent.position.z += delta.z
                        break
                    default:
                        print("oops")
                }
                
                                
                entity.components[DragRotateComponent.self]?.dragGesture = nil
            }
            
        }
    }
}

