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
    case cross = "Cross"
    case sin = "Sine"
    case cos = "Cosine"
}

@Observable
class ViewModel {
    var gizmoPositions: [simd_float3] = .init()
    var gizmos:[Entity] = .init()
    let numGizmos = 12
    let gizmoRadius:Float = 0.1
    let layoutWidth:Float = 2.4
    let shapeOfffset = simd_float3([0, 1.6, -2])
    let animateToFarthest = true
    
    func updateGizmoPositions(curveFunction:(_:Float) -> Float) {
        gizmoPositions = gizmos.enumerated().map {
            index, gizmo in
            
            return computeCurveLayout(value: index, maxValue: gizmos.count, curveFunction: curveFunction) + shapeOfffset
        }
    }
    
    func updateGizmoPositions(shape:LayoutShape) {
        gizmoPositions = gizmos.enumerated().map {
            index, gizmo in
            
            let position = switch shape {
            case .square:
                computeSquareLayout(value: index, maxValue: numGizmos)
            case .circle:
                computeCircleLayout(value: index, maxValue: numGizmos)
            case .cross:
                computeXLayout(value: index, maxValue: numGizmos)
            case .sin:
                computeCurveLayout(value: index, maxValue: numGizmos, curveFunction: sinCurve)
            case .cos:
                computeCurveLayout(value: index, maxValue: numGizmos, curveFunction: cosCurve)
            }
            
            return position + shapeOfffset
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
    
    func sinCurve(_ progress: Float) -> Float {  
        let xWdith:Float = 4
        let factor = xWdith * progress - xWdith / 2

        return sin(factor * .pi/2)
    }
    
    func cosCurve(_ progress: Float) -> Float {
        let xWdith:Float = 4
        let factor = xWdith * progress - xWdith / 2

        return cos(factor * .pi/2)
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
        let progress = x / layoutWidth
        let y = curveFunction(progress)  / 2
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
        let gizmoDiameter = gizmoRadius * 2
        
        
        var x:Float = 0
        var y:Float = 0
        
        if value == 1 {
            y = layoutWidth
        }
        else if value == 2 {
            x = layoutWidth
            y = layoutWidth
        }
        else if value == 3 {
            x = layoutWidth
        }
        else if value != 0 {
            let lineNum = value % 4
            //| | _ - = 0, 1, 2, 3
            let isVerticle = lineNum < 2
            let numValuesForSides = Float(maxValue - 4)
            let valuesPerVerticle = ceil(numValuesForSides / 4)
            let position = value / 4

            print("vpv", valuesPerVerticle)
            
            if(isVerticle) {
                let numSpaces = valuesPerVerticle + 1
                let gizmoPadding = (layoutWidth - numSpaces * gizmoDiameter) / numSpaces
                y = Float(position) * (gizmoPadding + gizmoDiameter)

                if (lineNum == 1) {
                    x = layoutWidth
                }
            }
            else {
                let valuesPerHorizontal = numValuesForSides / 2 - valuesPerVerticle
                let numSpaces = valuesPerHorizontal + 1
                let gizmoPadding = (layoutWidth - numSpaces * gizmoDiameter) / numSpaces
                x = Float(position) * (gizmoPadding + gizmoDiameter)

                if (lineNum == 3) {
                    y = layoutWidth
                }
            }

        }

        return [x, y, 0] - [layoutWidth, layoutWidth, 0] / 2
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
        var positions = Array(viewModel.gizmoPositions)
        viewModel.gizmos.enumerated().forEach {
            index, gizmo in
            let position:simd_float3 = viewModel.gizmoPositions[index]

            if animate {
                positions = positions.sorted {
                    left, right in
                    let gizmoPosition = gizmo.position
                    let distanceL = distance(gizmoPosition, left)
                    let distanceR = distance(gizmoPosition, right)
                    
                    return viewModel.animateToFarthest ? distanceL < distanceR : distanceL > distanceR
                }
                
                if let closestPosition = positions.popLast() {
                    var destination = gizmo.transform
                    destination.translation = closestPosition
                    gizmo.move(to: destination, relativeTo: gizmo.parent, duration: 1, timingFunction: .easeInOut)
                }
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
            
            viewModel.updateGizmoPositions(shape: .sin)
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
