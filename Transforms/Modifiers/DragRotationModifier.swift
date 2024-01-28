/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
A modifier for turning drag gestures into rotation.
*/

import SwiftUI
import RealityKit

extension View {
    /// Enables people to drag an entity to rotate it, with optional limitations
    /// on the rotation in yaw and pitch.
    func dragRotation() -> some View {
        self.modifier(
            DragRotationModifier()
        )
    }
}

/// A modifier converts drag gestures into entity rotation.
private struct DragRotationModifier: ViewModifier {
    @State private var previousDragLocation:simd_float3?

    func body(content: Content) -> some View {
        let dragGesture = DragGesture(minimumDistance: 0.0)
            .targetedToEntity(where: .has(DragRotateComponent.self))
        .onChanged { value in
            let location3D = value.convert(value.location3D, from: .local, to: .scene)
            
            if let previousDragLocation = previousDragLocation {
                value.entity.components[DragRotateComponent.self]?.delta = location3D - previousDragLocation
            }
            
            previousDragLocation = location3D
        }
        .onEnded {
            value in
            value.entity.components[DragRotateComponent.self]?.delta = nil
            previousDragLocation = nil
        }
        
        content.gesture(dragGesture)
    }
}
