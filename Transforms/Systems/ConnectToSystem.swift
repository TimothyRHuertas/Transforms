//
//  ConnectToSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/26/24.
//
import RealityKit
import UIKit

public struct ConnectToSystem: System {
    public static var dependencies: [SystemDependency] {
        [.after(DragRotateSystem.self), .after(DragParentSystem.self )]
    }
    
    static let query = EntityQuery(where: .has(ConnectToComponent.self))
    
    public init(scene: RealityKit.Scene) {
    }
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query).filter({$0.parent != nil})
        
        for entity in entities {
            if let component =  entity.components[ConnectToComponent.self], let parent = entity.parent {
                let connectedToEntity = component.connectedToEntity
                let line = component.lineEntity
                
                line.components.set(LineComponent(from: entity.position, to: connectedToEntity.position))
                parent.addChild(line)
            }
        }
    }
}

