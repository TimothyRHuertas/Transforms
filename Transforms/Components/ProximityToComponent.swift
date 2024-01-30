//
//  ProximityToComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/29/24.
//

import RealityKit
import SwiftUI

public struct ProximityToComponent: Component {
    var entity: ModelEntity
    var distance:Float = 2
    var colorWhenClose = UIColor.purple
    var originalColor:UIColor?
    
    public init(entity:ModelEntity) {
        self.entity = entity
    }
}
