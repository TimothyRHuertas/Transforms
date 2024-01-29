//
//  ImmersiveView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

enum LayoutShape: String, CaseIterable {
    case square = "Square"
    case circle = "Circle"
    case x = "X"
}

@Observable
class ViewModel {
    var gizmoPositions: [simd_float3] = .init()
    var gizmos:[Entity] = .init()
    let numGizmos = 12
    let gizmoRadius:Float = 0.1
    let layoutWidth:Float = 2.4
    
    func updateGizmoPositions(curveFunction:(_:Float) -> Float) {
        gizmoPositions = gizmos.enumerated().map {
            index, gizmo in
            
            return computeCurveLayout(value: index, maxValue: gizmos.count, curveFunction: curveFunction)
        }
    }
    
    func updateGizmoPositions(shape:LayoutShape) {
        gizmoPositions = gizmos.enumerated().map {
            index, gizmo in
            
            return switch shape {
                
            case .square:
                computeSquareLayout(value: index, maxValue: gizmos.count)
            case .circle:
                computeCircleLayout(value: index, maxValue: gizmos.count)
            case .x:
                computeXLayout(value: index, maxValue: gizmos.count)
            }
        }
    }
    
    private func computeCircleLayout(value:Int, maxValue:Int) -> simd_float3 {
        let radius:Float = layoutWidth / 2
        let valueF = Float(value)
        let maxValueF = Float(maxValue)
        let radians = valueF * 2.0 * .pi / maxValueF
        let x = radius * cos(radians)
        let y = radius * sin(radians)
                    
        return [x, y, 0]
    }
    
    // https://github.com/manuelCarlos/Easing/blob/main/Sources/Easing/Easing.swift#L170C24-L170C38
    func computeCurveLayout(value: Int, maxValue: Int, curveFunction:(_:Float) -> Float) -> simd_float3 {
        let valueF = Float(value)
        let maxValueF = Float(maxValue)
        let gizmoDiameter = gizmoRadius * 2
        let totalWidth = layoutWidth
        let numSpacesNeeded = maxValueF - 1
        let totalWidthOccupiedByGizmos = numSpacesNeeded * gizmoDiameter
        let gizmoPadding = (totalWidth - totalWidthOccupiedByGizmos) / numSpacesNeeded
        let x = (gizmoPadding * valueF) + (gizmoDiameter * valueF)
        let y = curveFunction(x / totalWidth)
        let offset:Float = x - totalWidth/2
        
        return [offset, y, 0]
    }
    
    func computeXLayout(value:Int, maxValue:Int) -> simd_float3 {
        let valueF = Float(value % (maxValue/2))
        let maxValueF = Float(maxValue/2)
        let gizmoDiameter = gizmoRadius * 2
        let totalWidth = layoutWidth
        let numSpacesNeeded = maxValueF - 1
        let totalWidthOccupiedByGizmos = numSpacesNeeded * gizmoDiameter
        let gizmoPadding = (totalWidth - totalWidthOccupiedByGizmos) / numSpacesNeeded
        let x = (gizmoPadding * valueF) + (gizmoDiameter * valueF)
        let y:Float = (gizmoPadding * valueF) + (gizmoDiameter * valueF)
        let offsetX:Float = x - totalWidth/2
        let offsetY:Float = value >= maxValue/2 ? y - totalWidth/2 : totalWidth/2 - y

        return [offsetX, offsetY, 0]
    }
    
    func computeSquareLayout(value:Int, maxValue:Int) -> simd_float3 {
        let numSides = 4
        let valueF = Float(value)
        let maxValueF = Float(maxValue)
        let gizmoDiameter = gizmoRadius * 2
        let numSpacesNeeded = maxValueF/Float(numSides) - 1
        let totalWidthOccupiedByGizmos = numSpacesNeeded * gizmoDiameter
        let gizmoPadding = (layoutWidth - totalWidthOccupiedByGizmos) / numSpacesNeeded
        let side:Float = Float(value % numSides)
     
        let offset = (gizmoPadding + gizmoDiameter) * floor(valueF/4)
        let x:Float = switch side {
            case 0: //left
                0
            case 1: //right
                layoutWidth
            default: // top / bottom
                offset
        }
        
        let y:Float = switch side {
            case 2: //bottom
               0
            case 3: //top
                layoutWidth
            default: // left / right
                offset
        }
        
        let offsetX:Float = x  - layoutWidth/2
        let offsetY:Float = y - layoutWidth/2

        return [offsetX, offsetY, 0]
    }
}

let viewModel = ViewModel()

struct SettingsMenuView: View {
    var body: some View {
        HStack {
            VStack {
                ForEach(Array(LayoutShape.allCases), id: \.self) {
                    value in
                    Button(value.rawValue) {
                        Task {
                            viewModel.updateGizmoPositions(shape: value)
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
            position += [0, 1.6, -2]
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
            
            for _ in 1...viewModel.numGizmos {
                let gizmo = buildSphere(viewModel.gizmoRadius, .gray)
                viewModel.gizmos.append(gizmo)
                content.add(gizmo)
            }
            
            viewModel.updateGizmoPositions(shape: .square)
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
