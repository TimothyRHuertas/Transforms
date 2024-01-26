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
    func body(content: Content) -> some View {
        let dragGesture = DragGesture(minimumDistance: 0.0)
            .targetedToEntity(where: .has(DragRotateComponent.self))
        .onChanged { value in
            value.entity.components[DragRotateComponent.self]?.dragGesture = value
        }
        .onEnded {
            value in
            value.entity.components[DragRotateComponent.self]?.dragGesture = nil
        }
        
        content.gesture(dragGesture)
    }
}
