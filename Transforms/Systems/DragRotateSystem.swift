//
//  RotateSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import RealityKit
import ARKit
import UIKit

public struct DragRotateSystem: System {
    static let query = EntityQuery(where: .has(DragRotateComponent.self))
    let sensitivity:Float = 30

    private let arkitSession = ARKitSession()
    private let worldTrackingProvider = WorldTrackingProvider()

    public init(scene: RealityKit.Scene) {
        setUpSession()
    }

    func setUpSession() {
        Task {
            do {
                try await arkitSession.run([worldTrackingProvider])
            } catch {
                print("Error: \(error)")
            }
        }
    }
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query).filter({$0.components[DragRotateComponent.self]?.delta != nil})
        let deviceAnchor = worldTrackingProvider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())!
        let cameraTransform = Transform(matrix: deviceAnchor.originFromAnchorTransform)
        let cameraPosition = simd_make_float3(cameraTransform.matrix.columns.3)

        for entity in entities {
            let entityPosition = entity.position(relativeTo: nil)
            
            if let component = entity.components[DragRotateComponent.self], let delta = component.delta {
                let rotX = delta.x * sensitivity
                let rotY = delta.y * sensitivity
                let cols = cameraTransform.matrix.columns
                let cameraUp = simd_make_float3(cols.1)
                let right = simd_normalize(cross(cameraUp, entityPosition - cameraPosition))
                let yAxis = right.x > 0 ? -1 : 1
                
                entity.transform.rotation = simd_quatf(angle: rotX, axis: simd_float3([0, yAxis, 0])) * entity.transform.rotation
                entity.transform.rotation = simd_quatf(angle: rotY, axis: right) * entity.transform.rotation
                
                entity.components[DragRotateComponent.self]?.delta = nil
            }
            
        }
    }
}

