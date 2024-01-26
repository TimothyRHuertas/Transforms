//
//  DragParentModifier.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/26/24.
//

import SwiftUI
import RealityKit

extension View {
    func dragParent() -> some View {
        self.modifier(
            DragParentModifier()
        )
    }
}

/// A modifier converts drag gestures into entity rotation.
private struct DragParentModifier: ViewModifier {
    @State private var previousDragLocation:simd_float3?

    func body(content: Content) -> some View {
        let dragGesture = DragGesture(minimumDistance: 0.0)
            .targetedToEntity(where: .has(DragParentComponent.self))
        .onChanged { value in
            let location3D = value.convert(value.location3D, from: .local, to: .scene)
            
            if let previousDragLocation = previousDragLocation {
                value.entity.components[DragParentComponent.self]?.delta = location3D - previousDragLocation
            }
            
            previousDragLocation = location3D
        }
        .onEnded {
            value in
            value.entity.components[DragParentComponent.self]?.delta = nil
            previousDragLocation = nil
        }
        
        content.gesture(dragGesture)
    }
}
