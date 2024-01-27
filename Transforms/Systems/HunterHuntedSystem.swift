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
    let movement:Float = 0.001
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
                    hunter.position += hunterToPreyDirection * movement
                }
                print(lookness, canSee)
                
            }
            
        
        }
    }
}
