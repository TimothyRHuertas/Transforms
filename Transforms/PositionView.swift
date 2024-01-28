//
//  ImmersiveView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

enum Arrangements: String, CaseIterable {
    case xyCircle = "Circle XY"
    case yzCircle = "Circle YZ"
    case xzCircle = "Circle XZ"
    
    var isCircle : Bool {
        get {
            return switch self {
            case .xyCircle, .yzCircle, .xzCircle:
                true
            }
        }
        
    }
}

@Observable
class ViewModel {
    var arrangement:Arrangements = .xyCircle
}

let viewModel = ViewModel()

struct SettingsMenuView: View {
    var body: some View {
        VStack {
            ForEach(Array(Arrangements.allCases), id: \.self) {
                value in
                
                Button(value.rawValue) {
                    Task {
                        viewModel.arrangement = value
                        print("oops", value)
                    }
                    
                }
            }
        }
    }
    
}

struct PositionView: View {
    let settingsMenuTag = "settingsMenu"
    @State private var gizmos:[Entity] = .init()
    let max:Float = 2.0 * .pi
    let steps = 10
    
    private func buildSphere(_ radius:Float, _ color:UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
//        entity.components.set(DragRotateComponent())
//        entity.components.set(DragTransformComponent())

        return entity
    }
    
    private func computeCircleLayout(index:Int) -> simd_float3 {
        let radius:Float = 1
        let radians = Float(index) * max / Float(gizmos.count)
        let x = radius * cos(radians)
        let y = radius * sin(radians)
                    
        return switch viewModel.arrangement {
            case .xyCircle:
                [x, y, 0]
            case .yzCircle:
                [x, 0, y]
            case .xzCircle:
                [0, x, y]
        }
            }
    
    private func layoutGizmos(_ animate:Bool = false) {
        gizmos.enumerated().forEach {
            index, gizmo in
            var position:simd_float3 = if viewModel.arrangement.isCircle {
                computeCircleLayout(index: index)
            }
            else {
                [0, 0, 0]
            }
            
            position += [0, 1.8, -2]
            
            if animate {
                var destination = gizmo.transform
                destination.translation = position
                gizmo.move(to: destination, relativeTo: gizmo.parent, duration: 1, timingFunction: .easeInOut)
            }
            else {
                gizmo.position = position
            }
        }
    }
    
    var body: some View {
        RealityView { content, attachments in
            let headAnchor = AnchorEntity(.head)
            headAnchor.position = [0.75, 0.3, -1]
            
            if let settingsMenu = attachments.entity(for: settingsMenuTag) {
                headAnchor.addChild(settingsMenu)
                content.add(headAnchor)
            }
            
            for _ in 1...steps {
                let gizmo = buildSphere(0.1, .gray)
                gizmos.append(gizmo)
                content.add(gizmo)
            }
            
            layoutGizmos()
        }
        attachments: {
            Attachment(id: settingsMenuTag) {
                SettingsMenuView()
                .padding(40)
                .glassBackgroundEffect()
            }
            
        }
        .onChange(of: viewModel.arrangement) {
            layoutGizmos(true)
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    PositionView()
        .previewLayout(.sizeThatFits)
}
