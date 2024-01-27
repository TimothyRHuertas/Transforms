//
//  ConnectToComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/26/24.
//

import RealityKit


public struct ConnectToComponent: Component {
    var connectedToEntity: ModelEntity
    var lineEntity = ModelEntity()
    
    public init(entity:ModelEntity) {
        self.connectedToEntity = entity
    }
}
