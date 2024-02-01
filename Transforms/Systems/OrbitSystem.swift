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
                let elapedTime =  Float(currentTime - component.startTime)
                let timeSinceLastTrip = elapedTime - (floor(elapedTime / component.roundTripTimeInSeconds) * component.roundTripTimeInSeconds)
                let orbitPercentage = (timeSinceLastTrip / component.roundTripTimeInSeconds)
                let rotationAngle:Float = 2 * .pi * orbitPercentage
                let orbitsPosition = component.orbits.position
                
                let y = cos(rotationAngle) * tan(.pi / component.orbitAngleInRadians)
                let x = cos(rotationAngle)
                let z = sin(rotationAngle)
                
                entity.position = [x, y, z] + orbitsPosition
            }
            
        }
    }
}

