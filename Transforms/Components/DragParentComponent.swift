//
//  DragParentComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import RealityKit
import SwiftUI


public struct DragParentComponent: Component {
    var dragGesture: EntityTargetValue<DragGesture.Value>?
    var axis: Axis3D
    
    public init(axis: Axis3D) {
        self.axis = axis
    }
}
