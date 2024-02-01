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
    @State private var previousDragGesture:EntityTargetValue<DragGesture.Value>?

    func body(content: Content) -> some View {
        let dragGesture = DragGesture(minimumDistance: 0.0)
            .targetedToEntity(where: .has(DragRotateComponent.self))
        .onChanged { gesture in            
            if let previousDragGesture = previousDragGesture {
                gesture.entity.components[DragRotateComponent.self]?.previousGesture = previousDragGesture
                gesture.entity.components[DragRotateComponent.self]?.currentGesture = gesture
            }
            
            previousDragGesture = gesture
        }
        .onEnded {
            gesture in
            gesture.entity.components[DragRotateComponent.self]?.previousGesture = nil
            gesture.entity.components[DragRotateComponent.self]?.currentGesture = nil
            previousDragGesture = nil
        }
        
        content.gesture(dragGesture)
    }
}
