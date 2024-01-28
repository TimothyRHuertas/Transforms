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
    let sensitivity:Float = 0.4

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
        let entities = scene.performQuery(Self.query)//.filter({$0.components[DragRotateComponent.self]?.dragGesture != nil})
        let deviceAnchor = worldTrackingProvider.queryDeviceAnchor(atTimestamp: CACurrentMediaTime())!
        let cameraTransform = Transform(matrix: deviceAnchor.originFromAnchorTransform)

        for entity in entities {
            let entityPosition = entity.position(relativeTo: nil)
            let cameraPosition = cameraTransform.translation
            let cameraToEntity = normalize(cameraPosition - entityPosition)
            

            print(cameraToEntity)

            if let component = entity.components[DragRotateComponent.self], let dragGesture = component.dragGesture {
                let location3D = dragGesture.convert(dragGesture.location3D, from: .local, to: .scene)
                let startLocation3D = dragGesture.convert(dragGesture.startLocation3D, from: .local, to: .scene)
                
                
                let delta = (location3D - startLocation3D) * (cameraToEntity.z >= 0 ? 1 : -1)
                let yaw:Float = component.baseYaw + delta.x * sensitivity
                let pitch = component.basePitch + delta.y * sensitivity

                entity.transform.rotation = simd_quatf(.init(angle: .radians(Double(-pitch)), axis: .x)) * simd_quatf(.init(angle: .radians(Double(yaw)), axis: .y))
                
                entity.components[DragRotateComponent.self]?.dragGesture = nil
                entity.components[DragRotateComponent.self]?.baseYaw = yaw
                entity.components[DragRotateComponent.self]?.basePitch = pitch
            }
            
        }
    }
}

