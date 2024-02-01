//
//  OrbitSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 2/1/24.
//

import RealityKit

public struct OrbitSystem : System {
    static let query = EntityQuery(where: .has(OrbitComponent.self))
    public init(scene: RealityKit.Scene) {
    }

    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query)

        for entity in entities {
            if let component = entity.components[OrbitComponent.self] {
               print("todo")
                
            }
            
        }
    }
}

