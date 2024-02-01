//
//  OrbitSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 2/1/24.
//

import RealityKit
import Foundation

public struct OrbitSystem : System {
    static let query = EntityQuery(where: .has(OrbitComponent.self))
    public init(scene: RealityKit.Scene) {
    }

    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query)

        for entity in entities {
            if let component = entity.components[OrbitComponent.self] {
                let currentTime = Date().timeIntervalSince1970
                let timeDelta =  Float(currentTime - component.startTime)
                let timeSinceLastTrip = timeDelta - floor(timeDelta / component.roundTripTimeInSeconds)
                let rotationAngle:Float = 2 * .pi * timeSinceLastTrip
                let orbitsPosition = component.orbits.position
                
                let y = orbitsPosition.y
                let x = cos(rotationAngle) + orbitsPosition.x
                let z = sin(rotationAngle) + orbitsPosition.z
                
                entity.position = [x, y, z]
                
                print("todo", timeSinceLastTrip, rotationAngle)
                
            }
            
        }
    }
}

