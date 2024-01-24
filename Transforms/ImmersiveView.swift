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
    @State private var baseYaw: Float = 0
    @State private var yaw: Float = 0
    @State private var basePitch: Float = 0
    @State private var pitch: Float = 0
    @State private var gizmo:Entity?
    
    func buildCylinder(_ height:Float, _ color: UIColor) -> Entity {
        let material = UnlitMaterial.init(color: color)
        let mesh = MeshResource.generateCylinder(height: height, radius: 0.01)

        return ModelEntity(mesh: mesh, materials: [material])
    }
    
    func buildSphere(_ radius:Float, _ color:UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        
        let entity = ModelEntity(mesh: mesh, materials: [material])
        
        entity.components.set(InputTargetComponent())
        entity.generateCollisionShapes(recursive: true)

        entity.components.set(CollisionComponent(shapes: entity.collision!.shapes))

        return entity
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
    
    private func spin(
        displacement: Float,
        base: Float
    ) -> Float {
        let sensitivity:Float = 10
        return base + displacement * sensitivity
    }
    
    var body: some View {
        RealityView { content in
            gizmo = buildGizmo(.gray)
            if let gizmo = gizmo {
                gizmo.position = [0, 1.8, -2]
                content.add(gizmo)
                print("matrix cols", gizmo.transformMatrix(relativeTo: gizmo.parent).columns)
            }
            
        }
        .gesture(DragGesture(minimumDistance: 0.0)
            .targetedToAnyEntity()
            .onChanged { value in
                print("TImmy")
                // Find the current linear displacement.
                let location3D = value.convert(value.location3D, from: .local, to: .scene)
                let startLocation3D = value.convert(value.startLocation3D, from: .local, to: .scene)
                let delta = location3D - startLocation3D

                yaw = spin(displacement: delta.x, base: baseYaw)
                pitch = spin(displacement: delta.y, base: basePitch)
//                gizmo!.transform.rotation = simd_quatf(vector: [pitch, 0, 0, 0])
                
                gizmo!.transform.rotation = simd_quatf(.init(angle: .radians(Double(-pitch)), axis: .x)) * simd_quatf(.init(angle: .radians(Double(yaw)), axis: .y))
//                gizmo!.transform.rotation = simd_quatf(.init(angle: .radians(Double(yaw)), axis: .y))


                print(yaw, pitch, gizmo!.transform.rotation)
                // Use an interactive spring animation that becomes
                // a spring animation when the gesture ends below.
//                withAnimation(.interactiveSpring) {
//                    yaw = spin(displacement: Double(delta.x), base: baseYaw, limit: yawLimit)
//                    pitch = spin(displacement: Double(delta.y), base: basePitch, limit: pitchLimit)
//                }
                
                
            }
        )
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
