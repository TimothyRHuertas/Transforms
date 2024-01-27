//
//  ConnectView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/26/24.
//

import SwiftUI
import RealityKit

struct ConnectView: View {
    private func buildSphere(_ radius:Float, _ color:UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        entity.components.set(DragRotateComponent())
        entity.components.set(DragTransformComponent())

        return entity
    }
    
    private func buildCylinder(_ height:Float, _ color: UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateCylinder(height: height, radius: 0.02)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        let parent = ModelEntity()
        
        entity.transform.rotation = simd_quatf(.init(angle: .degrees(90.0), axis: .z))
        entity.position += [height/2, 0, 0]
        
        parent.addChild(entity)

        return parent
    }
    
    var body: some View {
        RealityView { content in
            let gizmo = buildSphere(0.1, .gray)
            gizmo.position = [1, 2, -2]
            content.add(gizmo)
            
            let gizmo2 = buildSphere(0.1, .gray)
            gizmo2.position = [2, 1, -2]
            content.add(gizmo2)
            
            //https://swiftui-lab.com/trigonometric-recipes-for-swiftui/
            let differnce = gizmo2.position - gizmo.position
            var alpha = atan2(differnce.y, differnce.x) // calculate angle
            alpha = alpha < 0 ? alpha + (.pi * 2) : alpha
            let distance = length(differnce)
            let lineEnity = buildCylinder(distance, .cyan)
            lineEnity.position = gizmo.position
            lineEnity.transform.rotation = simd_quatf(.init(angle: .radians(Double(alpha)), axis: .z))
            content.add(lineEnity)
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    ConnectView()
}
