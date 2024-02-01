//
//  ConnectView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/26/24.
//

import SwiftUI
import RealityKit

struct ConnectView: View {
    var body: some View {
        RealityView { content in
            let gizmo = BuildSphere.buildSphere(0.1, .gray)
            gizmo.position = [1, 2, -2]
            content.add(gizmo)
            
            let gizmo2 = BuildSphere.buildSphere(0.1, .gray)
            gizmo2.position = [-1, 1, -3]
            content.add(gizmo2)
            
            gizmo.components.set(ConnectToComponent(entity: gizmo2))            
        }
        .dragRotation()
        .dragParent()
    }
}

#Preview {
    ConnectView()
}
