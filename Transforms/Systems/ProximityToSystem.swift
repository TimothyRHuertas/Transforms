//
//  ProximityToSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/29/24.
//

import Foundation

import RealityKit
import UIKit

public struct ProximityToSystem: System {
    public static var dependencies: [SystemDependency] {
        [.after(DragRotateSystem.self), .after(DragParentSystem.self )]
    }
    
    static let query = EntityQuery(where: .has(ProximityToComponent.self))
    
    public init(scene: RealityKit.Scene) {
    }
    
    private func updateColor(entity: ModelEntity, color: UIColor) {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        entity.model?.materials = [material]
    
    }
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query)
        
        for entity in entities {
            if let component =  entity.components[ProximityToComponent.self], let modelEnity = entity as? ModelEntity, let material = modelEnity.model?.materials.first as? SimpleMaterial {
                let connectedToEntity = component.entity
                let differnce = connectedToEntity.position - entity.position
                let distance = length(differnce)
                
                
                if(distance <= component.distance) {
                    if material.color.tint != component.colorWhenClose {
                        if component.originalColor == nil {
                            entity.components[ProximityToComponent.self]?.originalColor = material.color.tint
                        }
                        
                        updateColor(entity: modelEnity, color: component.colorWhenClose)
                    }
                }
                else if let originalColor = component.originalColor, material.color.tint != originalColor {
                    updateColor(entity: modelEnity, color: originalColor)
                }
            }
        }
    }
}
