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
    @State private var previousDragLocation:Point3D?
    
    private func buildCylinder(_ height:Float, _ color: UIColor) -> Entity {
        let material = UnlitMaterial.init(color: color)
        let mesh = MeshResource.generateCylinder(height: height, radius: 0.01)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        makeDragable(entity)
        
        return entity
    }
    
    private func buildSphere(_ radius:Float, _ color:UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
        makeDragable(entity)
        entity.components.set(DragRotateComponent())

        return entity
    }
    
    private func buildGizmo(_ color:UIColor) -> Entity {
        let sphere = buildSphere(0.1, color)
        
        let lineLength:Float = 0.5
        let lineOffset:Float = lineLength/2
        let lineY = buildCylinder(lineLength, .red)
        lineY.position.y = lineOffset
        lineY.components[DragParentComponent.self] = DragParentComponent(axis: .y)
        sphere.addChild(lineY)
        
        let lineX = buildCylinder(lineLength, .green)
        lineX.position.x = lineOffset
        lineX.transform.rotation = simd_quatf(.init(angle: .degrees(90.0), axis: .z))
        lineX.components[DragParentComponent.self] = DragParentComponent(axis: .x)
        sphere.addChild(lineX)
        
        let lineZ = buildCylinder(lineLength, .blue)
        lineZ.position.z = lineOffset
        lineZ.transform.rotation = simd_quatf(.init(angle: .degrees(90.0), axis: .x))
        lineZ.components[DragParentComponent.self] = DragParentComponent(axis: .z)

        sphere.addChild(lineZ)
        
        return sphere
    }
    
    private func makeDragable(_ entity:ModelEntity) {
        entity.components.set(InputTargetComponent())
        entity.generateCollisionShapes(recursive: true)
        entity.components.set(CollisionComponent(shapes: entity.collision!.shapes))
    }
    
    var body: some View {
        RealityView { content in
            let gizmo = buildGizmo(.gray)
            gizmo.position = [0, 1.8, -2]
            content.add(gizmo)
            print("matrix cols", gizmo.transformMatrix(relativeTo: gizmo.parent).columns)            
        }
        .gesture(DragGesture(minimumDistance: 0.0)
            .targetedToAnyEntity()
            .onChanged { value in
                var delta:Vector3D = Vector3D(x: 0, y: 0, z: 0)
                
                if let previousDragLocation = previousDragLocation {
                    delta = value.location3D - previousDragLocation
                }
                previousDragLocation = value.location3D
                
                value.entity.components[DragRotateComponent.self]?.dragGesture = value
                value.entity.components[DragParentComponent.self]?.delta = delta
            }
            .onEnded {
                value in
                value.entity.components[DragRotateComponent.self]?.dragGesture = nil                
                value.entity.components[DragParentComponent.self]?.delta = nil
                previousDragLocation = nil
            }
        )
    }
}

#Preview {
    ImmersiveView()
        .previewLayout(.sizeThatFits)
}
