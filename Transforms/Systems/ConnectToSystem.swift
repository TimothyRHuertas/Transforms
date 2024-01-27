//
//  ConnectToSystem.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/26/24.
//
import RealityKit
import UIKit

public struct ConnectToSystem: System {
    public static var dependencies: [SystemDependency] {
        [.after(DragRotateSystem.self), .after(DragParentSystem.self )]
    }
    
    static let query = EntityQuery(where: .has(ConnectToComponent.self))
    
    public init(scene: RealityKit.Scene) {
    }
    
    private func updateLine(line: ModelEntity, height:Float, color: UIColor) -> ModelEntity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateCylinder(height: height, radius: 0.02)
        var entity:ModelEntity? = line.children.first as? ModelEntity
        
        if entity == nil  {
            entity = ModelEntity(mesh: mesh, materials: [material])
            line.addChild(entity!)
        }
        else {
            try! entity?.model?.mesh.replace(with: mesh.contents)
        }

        if let entity = entity {
            entity.transform.rotation = simd_quatf(.init(angle: .degrees(90.0), axis: .z)) * simd_quatf(.init(angle: .degrees(90.0), axis: .x))
            entity.position = [0, 0, height/2]
        }

  
        return line
    }
    
    public func update(context: SceneUpdateContext) {
        let scene = context.scene
        let entities = scene.performQuery(Self.query).filter({$0.parent != nil})
        
        for entity in entities {
            if let component =  entity.components[ConnectToComponent.self] {
                let connectedToEntity = component.connectedToEntity
                let line = component.lineEntity
                let differnce = connectedToEntity.position - entity.position
                let distance = length(differnce)
                let lineEntity = updateLine(line: line, height: distance, color: .cyan)

                
                //https://swiftui-lab.com/trigonometric-recipes-for-swiftui/
                lineEntity.position = entity.position
                lineEntity.look(at: connectedToEntity.position, from: lineEntity.position, relativeTo: lineEntity.parent, forward: .positiveZ)
                entity.parent?.addChild(lineEntity)
                entity.components[ConnectToComponent.self]?.lineEntity = lineEntity
            }
        }
    }
}

