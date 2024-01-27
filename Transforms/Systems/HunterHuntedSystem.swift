//
//  HunterHuntedSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/27/24.
//

import RealityKit


public struct HunterHuntedSystem: System {
    static let query = EntityQuery(where: .has(HunterHuntedComponent.self))
    
    // 0 is 180 degree field of view and 1 means you'd have to have a direct line of site
    let preciseness:Float = 0.5
    let movementSpeed:Float = 0.005
    let roationSpeed:Float = 0.01
    public static var dependencies: [SystemDependency] {
        [.after(DragRotateSystem.self), .after(DragParentSystem.self )]
    }
    
    public init(scene: RealityKit.Scene) {
    }
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query)
        let hunters = entities.filter({$0.components[HunterHuntedComponent.self]!.isHunter})
        let hunted = entities.filter({$0.components[HunterHuntedComponent.self]!.isHunter == false})
    
        for hunter in hunters {
        
            let hunterPosition = hunter.position(relativeTo: nil)
            let hunterLookDirection = simd_make_float3(hunter.transformMatrix(relativeTo: nil).columns.2)
            
            for prey in hunted {
                let preyPosition = prey.position(relativeTo: nil)
                let hunterToPreyDirection = normalize(preyPosition - hunterPosition)
                let lookness = dot(hunterToPreyDirection, hunterLookDirection)
                let canSee = lookness >= preciseness
                
                if(canSee) {
                    let hackHunter = hunter.clone(recursive: false)
                    hackHunter.look(at: preyPosition, from: hunterPosition, relativeTo: nil, forward: .positiveZ)
                    let desiredRotation = hackHunter.transform.rotation
                    let hunterRotation = hunter.transform.rotation
                    
                    if(desiredRotation == hunterRotation) {
                        let targetPosition = hunter.position + hunterToPreyDirection * movementSpeed
                        let distance = distance(preyPosition, targetPosition)

                        hunter.position = distance > movementSpeed * 2 ? targetPosition : preyPosition
                    }
                    else {
                        let desiredRotationVector = desiredRotation.vector
                        let hunterRotationVector = hunterRotation.vector
                        let rotationDelta = normalize(desiredRotationVector - hunterRotationVector)
                        
                        //todo...the same for position
                        let targetRotation = hunterRotation + simd_quatf(vector: rotationDelta * roationSpeed)
                        let targetRotationVector = targetRotation.vector
                        let distance = distance(targetRotationVector, desiredRotationVector)
                        hunter.transform.rotation =  distance > roationSpeed * 2 ? targetRotation : desiredRotation
                        print(distance)
                    }
                }
                
            }
            
        
        }
    }
}
