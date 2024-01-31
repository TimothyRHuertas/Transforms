//
//  RotateToHitComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/30/24.
//

import RealityKit

public struct RotateToHitComponent: Component {
    var entityName:String
    var previousRotation:simd_quatf?
    
    public init(entityName:String) {
        self.entityName = entityName
    }
}
