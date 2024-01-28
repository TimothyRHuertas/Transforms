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
}

@Observable
class ViewModel {
    var gizmoPositions: [simd_float3] = .init()
    var gizmos:[Entity] = .init()
    let steps = 10
    let gizmoRadius:Float = 0.1
    let layoutWidth:Float = 2.0
    
    func updateGizmoPositions(arrangement:Arrangements) {
        gizmoPositions = gizmos.enumerated().map {
            index, gizmo in
            
            return computeCircleLayout(value: index, maxValue: gizmos.count, arrangement: arrangement)
        }
    }
    
    func updateGizmoPositions(curveFunction:(_:Float) -> Float) {
        gizmoPositions = gizmos.enumerated().map {
            index, gizmo in
            
            return computeCurveLayout(value: index, maxValue: gizmos.count, curveFunction: curveFunction)
        }
    }
    
    private func computeCircleLayout(value:Int, maxValue:Int, arrangement: Arrangements) -> simd_float3 {
        let radius:Float = layoutWidth / 2
        let valueF = Float(value)
        let maxValueF = Float(maxValue)
        let radians = valueF * 2.0 * .pi / maxValueF
        let x = radius * cos(radians)
        let y = radius * sin(radians)
                    
        return switch arrangement {
            case .xyCircle:
                [x, y, 0]
            case .yzCircle:
                [x, 0, y]
            case .xzCircle:
                [0, x, y]
        }
    }
    
    // https://github.com/manuelCarlos/Easing/blob/main/Sources/Easing/Easing.swift#L170C24-L170C38
    func computeCurveLayout(value: Int, maxValue: Int, curveFunction:(_:Float) -> Float) -> simd_float3 {
        let valueF = Float(value)
        let maxValueF = Float(maxValue)
        let gizmoWidth = gizmoRadius * 2
        let totalWidth = layoutWidth
        let numSpacesNeeded = maxValueF - 1
        let totalWidthOccupiedByGizmos = numSpacesNeeded * gizmoWidth
        let gizmoPadding = (totalWidth - totalWidthOccupiedByGizmos) / numSpacesNeeded
        let x = (gizmoPadding * valueF) + (gizmoWidth * valueF)
        let y = curveFunction(x / totalWidth)
        let offset:Float = x - totalWidth/2
        
        return [offset, y, 0]
    }
}

let viewModel = ViewModel()

struct SettingsMenuView: View {
    var body: some View {
        HStack {
            VStack {
                ForEach(Array(Arrangements.allCases), id: \.self) {
                    value in
                    Button(value.rawValue) {
                        Task {
                            viewModel.updateGizmoPositions(arrangement: value)
                        }
                        
                    }
                }
            }
            
            let curves:[Curve<Float>] = Array(Curve.allCases)

            VStack {
                ForEach(curves, id: \.self) {
                    curve in
                    Button(curve.rawValue) {
                        Task {
                            viewModel.updateGizmoPositions(curveFunction: curve.easeIn)

                        }
                        
                    }
                }
            }
        }
    }
    
}

struct PositionView: View {
    let settingsMenuTag = "settingsMenu"
    
    private func buildSphere(_ radius:Float, _ color:UIColor) -> Entity {
        let material = SimpleMaterial.init(color: color, isMetallic: true)
        let mesh = MeshResource.generateSphere(radius: radius)
        let entity = ModelEntity(mesh: mesh, materials: [material])
//        entity.components.set(DragRotateComponent())
//        entity.components.set(DragTransformComponent())

        return entity
    }
    
    
    private func layoutGizmos(_ animate:Bool = false) {
        viewModel.gizmos.enumerated().forEach {
            index, gizmo in
            var position:simd_float3 = viewModel.gizmoPositions[index]
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
            
            for _ in 1...viewModel.steps {
                let gizmo = buildSphere(viewModel.gizmoRadius, .gray)
                viewModel.gizmos.append(gizmo)
                content.add(gizmo)
            }
            
            viewModel.updateGizmoPositions(arrangement: .xyCircle)
            layoutGizmos()
        }
        attachments: {
            Attachment(id: settingsMenuTag) {
                SettingsMenuView()
                .padding(40)
                .glassBackgroundEffect()
            }
            
        }
        .onChange(of: viewModel.gizmoPositions) {
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
