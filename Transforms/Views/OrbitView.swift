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
                gizmo2.components.set(try OrbitComponent(orbits: gizmo, radius: 0.8, tiltAngleInRadians: .pi * 2 * orbitViewModel.tilt, layout: orbitViewModel.layout))
                
                content.add(gizmo2)
                
                orbitViewModel.gizmo2 = gizmo2
            }
            catch {
                print("Unexpected error: \(error).")
            }
            
        }
        update: {
            _, _ in
            do {
                if let gizmo2 = orbitViewModel.gizmo2, let component = gizmo2.components[OrbitComponent.self] {
                    gizmo2.components.set(try OrbitComponent(orbits: component.orbits, radius: component.radius, tiltAngleInRadians: .pi * 2 * orbitViewModel.tilt, layout: orbitViewModel.layout))
                }
            }
            catch {
                print("Unexpected error: \(error).")
            }
            
            print("update")
        }
        attachments: {
            Attachment(id: settingsMenuTag) {
                VStack {
                    Picker("Layout", selection: $orbitViewModel.layout) {
                        ForEach(OrbitComponentLayout.allCases) { layout in
                            Text(layout.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding(40)
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
