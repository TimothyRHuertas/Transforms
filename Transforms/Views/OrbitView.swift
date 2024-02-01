//
//  OrbitView.swift
//  Transforms
//
//  Created by Timothy Huertas on 2/1/24.
//

import SwiftUI
import RealityKit

struct OrbitView: View {
    @Observable
    class OrbitViewModel {
        var layout = OrbitComponentLayout.horizontal
        var tilt:Float = 0
        var gizmo2:Entity?
        var clockwise = true
    }
    
    @Bindable private var orbitViewModel = OrbitViewModel()
    
    let settingsMenuTag = "settingsMenu"

    init() {
        OrbitComponent.registerComponent()
        OrbitSystem.registerSystem()
    }

    var body: some View {
        RealityView {
            content, attachments in
            do {
                let headAnchor = AnchorEntity(.head)
                
                if let settingsMenu = attachments.entity(for: settingsMenuTag) {
                    settingsMenu.position = [0.75, 0.3, -1]
                    headAnchor.addChild(settingsMenu)
                }
                
                content.add(headAnchor)
                
                let gizmo = BuildSphere.buildSphere(0.1, UIColor.green)
                gizmo.position = [0, 1, -2]
                content.add(gizmo)
                
                let gizmo2 = BuildSphere.buildSphere(0.1, UIColor.gray, isDraggable: false, isRotateable: false)
                gizmo2.components.set(try OrbitComponent(orbits: gizmo, radius: 0.8, tiltAngleInRadians: orbitViewModel.tilt, layout: orbitViewModel.layout, clockwise: orbitViewModel.clockwise))
                
                content.add(gizmo2)
                
                orbitViewModel.gizmo2 = gizmo2
            }
            catch {
                print("Unexpected error: \(error).")
            }
            
        }
        update: {
            _, _ in
            if let gizmo2 = orbitViewModel.gizmo2, var component = gizmo2.components[OrbitComponent.self] {
                component.tiltAngleInRadians = orbitViewModel.tilt
                component.layout = orbitViewModel.layout
                component.clockwise = orbitViewModel.clockwise
                gizmo2.components.set(component)
            }
        }
        attachments: {
            Attachment(id: settingsMenuTag) {
                VStack {
                    Text("Settings").font(.largeTitle)

                    Picker("Layout", selection: $orbitViewModel.layout) {
                        ForEach(OrbitComponentLayout.allCases) { layout in
                            Text(layout.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    Text("Tilt")
                    let tiltBound:Float = .pi/4
                    Slider(
                        value: $orbitViewModel.tilt,
                        in: -tiltBound...tiltBound
                    )
                    
                    Toggle(isOn: $orbitViewModel.clockwise, label: {
                        Text("Clockwise")
                    })
                }
                .padding(40)
                .frame(width: 500)
                .glassBackgroundEffect()
            }
        }
//        .onChange(of: orbitViewModel.layout) {
//            updateGizmoOrbit()
//        }
//        .onChange(of: orbitViewModel.tilt) {
//            updateGizmoOrbit()
//        }
//        .onChange(of: orbitViewModel.clockwise) {
//            updateGizmoOrbit()
//        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    OrbitView()
}
