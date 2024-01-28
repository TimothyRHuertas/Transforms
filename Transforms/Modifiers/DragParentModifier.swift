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
    func body(content: Content) -> some View {
        let dragGesture = DragGesture(minimumDistance: 0.0)
            .targetedToEntity(where: .has(DragParentComponent.self))
        .onChanged { value in
            let location3D = value.convert(value.location3D, from: .local, to: .scene)
            value.entity.components[DragParentComponent.self]?.delta = location3D - value.convert(value.startLocation3D, from: .local, to: .scene)
        }
        .onEnded {
            value in
            value.entity.components[DragParentComponent.self]?.delta = nil
        }
        
        content.gesture(dragGesture)
    }
}
