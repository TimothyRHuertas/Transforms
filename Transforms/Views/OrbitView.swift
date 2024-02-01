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
        var radius:Float = 0.8
        var roundTripTimeInSeconds:Float = 3
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
                gizmo2.components.set(try OrbitComponent(orbits: gizmo, radius: orbitViewModel.radius, tiltAngleInRadians: orbitViewModel.tilt, layout: orbitViewModel.layout, clockwise: orbitViewModel.clockwise, roundTripTimeInSeconds: orbitViewModel.roundTripTimeInSeconds))
                
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
                component.radius = orbitViewModel.radius
                component.roundTripTimeInSeconds = orbitViewModel.roundTripTimeInSeconds
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
                    
                    Text("Radius")
                    Slider(
                        value: $orbitViewModel.radius,
                        in: 0.2...1.5
                    )
                    
                    Text("Round Trip Tim")
                    Slider(
                        value: $orbitViewModel.roundTripTimeInSeconds,
                        in: 1...10
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
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    OrbitView()
}
