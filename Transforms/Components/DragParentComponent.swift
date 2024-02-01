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
    var previousGesture: EntityTargetValue<DragGesture.Value>?
    var currentGesture: EntityTargetValue<DragGesture.Value>?
    
    public init(axis: Axis3D) {
        self.axis = axis
    }
}
