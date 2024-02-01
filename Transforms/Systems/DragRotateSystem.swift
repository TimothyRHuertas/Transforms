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
    let sensitivity:Float = 10

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
        if entities.isEmpty {return}
            
        guard let deviceAnchor = worldTrackingProvider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime()) else { return }
        let cameraTransform = Transform(matrix: deviceAnchor.originFromAnchorTransform)
        let cameraPosition = simd_make_float3(cameraTransform.matrix.columns.3)

        for entity in entities {
            let entityPosition = entity.position(relativeTo: nil)
            
            if let component = entity.components[DragRotateComponent.self], let delta = component.delta {
                let diff = normalize(entityPosition - cameraPosition)
                let axis = normalize(cross(normalize(delta), diff)) 

                entity.transform.rotation = simd_quatf(angle: 0.06, axis: axis) * entity.transform.rotation
                entity.components[DragRotateComponent.self]?.delta = nil
            }
            
        }
    }
}

