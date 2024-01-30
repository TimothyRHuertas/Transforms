//
//  RotateToHitSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/30/24.
//

import RealityKit
import UIKit

public struct RotateToHitSystem: System {
    public static var dependencies: [SystemDependency] {
        [.after(DragRotateSystem.self), .after(DragParentSystem.self )]
    }
    
    static let query = EntityQuery(where: .has(RotateToHitComponent.self))
    
    public init(scene: RealityKit.Scene) {
    }
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query)
        
        for entity in entities {
            if let component =  entity.components[RotateToHitComponent.self], let parent = entity.parent {
               print("TODO")
            }
        }
    }
}
