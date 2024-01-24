//
//  RotateSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import RealityKit


public struct DragRotateSystem: System {
    static let query = EntityQuery(where: .has(DragRotateComponent.self))
    let sensitivity:Float = 10

    public init(scene: RealityKit.Scene) {
    }
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query)

        for entity in entities {
            if let component = entity.components[DragRotateComponent.self], let dragGesture = component.dragGesture {
                let location3D = dragGesture.convert(dragGesture.location3D, from: .local, to: .scene)
                let startLocation3D = dragGesture.convert(dragGesture.startLocation3D, from: .local, to: .scene)
                let delta = location3D - startLocation3D

                let yaw = delta.x * sensitivity
                let pitch = delta.y * sensitivity

                entity.transform.rotation = simd_quatf(.init(angle: .radians(Double(-pitch)), axis: .x)) * simd_quatf(.init(angle: .radians(Double(yaw)), axis: .y))
            }
            
        }
    }
}

