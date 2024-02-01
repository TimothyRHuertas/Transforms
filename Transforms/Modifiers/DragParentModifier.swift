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
    @State private var previousDragGesture:EntityTargetValue<DragGesture.Value>?

    func body(content: Content) -> some View {
        let dragGesture = DragGesture(minimumDistance: 0.0)
            .targetedToEntity(where: .has(DragParentComponent.self))
        .onChanged { gesture in
            if let previousDragGesture = previousDragGesture {
                gesture.entity.components[DragParentComponent.self]?.previousGesture = previousDragGesture
                gesture.entity.components[DragParentComponent.self]?.currentGesture = gesture
            }
            
            previousDragGesture = gesture
        }
        .onEnded {
            gesture in
            gesture.entity.components[DragParentComponent.self]?.previousGesture = nil
            gesture.entity.components[DragParentComponent.self]?.currentGesture = nil
            previousDragGesture = nil
        }
        
        content.gesture(dragGesture)
    }
}
