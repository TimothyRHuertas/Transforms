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
    func buildCylinder(_ height:Float, _ color: UIColor) -> Entity {
        let material = UnlitMaterial.init(color: color)
        let mesh = MeshResource.generateCylinder(height: height, radius: 0.01)

        return ModelEntity(mesh: mesh, materials: [material])
    }
    
    func buildSphere(_ radius:Float, _ color:UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        
        return ModelEntity(mesh: mesh, materials: [material])
    }
    
    func buildGizmo(_ color:UIColor) -> Entity {
        let sphere = buildSphere(0.1, color)
        
        let lineLength:Float = 0.5
        let lineOffset:Float = lineLength/2
        let lineY = buildCylinder(lineLength, .red)
        lineY.position.y = lineOffset
        sphere.addChild(lineY)
        
        let lineX = buildCylinder(lineLength, .green)
        lineX.position.x = lineOffset
        lineX.transform.rotation = simd_quatf(.init(angle: .degrees(90.0), axis: .z))
        sphere.addChild(lineX)
        
        let lineZ = buildCylinder(lineLength, .blue)
        lineZ.position.z = lineOffset
        lineZ.transform.rotation = simd_quatf(.init(angle: .degrees(90.0), axis: .x))
        sphere.addChild(lineZ)
        
        return sphere
    }
    
    var body: some View {
        RealityView { content in
            let gizmo = buildGizmo(.gray)
            gizmo.position = [0, 1.8, -2]
            content.add(gizmo)

            print("matrix cols", gizmo.transformMatrix(relativeTo: gizmo.parent).columns)
        }
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
