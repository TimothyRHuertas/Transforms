//
//  ImmersiveView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    private func buildSphere(_ radius:Float, _ color:UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.components.set(DragRotateComponent())
        entity.components.set(DragTransformComponent())

        return entity
    }
    
    var body: some View {
        RealityView { content in
            let max:Float = 2.0 * .pi
            let steps = 10
            
            for step in 1...steps {
                let radius:Float = 1
                let radians = Float(step) * max/Float(steps)
                let x = radius * cos(radians)
                let y = radius * sin(radians)
                let gizmo = buildSphere(0.1, .gray)
                gizmo.position = [x, y, 0] + [0, 1.8, -2]
                content.add(gizmo)
                print(step)
            }
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
