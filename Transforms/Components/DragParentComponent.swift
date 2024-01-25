//
//  DragParentComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import RealityKit
import SwiftUI


public struct DragParentComponent: Component {
    var axis: Axis3D
    var delta: Vector3D?
    
    public init(axis: Axis3D) {
        self.axis = axis
    }
}
