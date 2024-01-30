//
//  NavigationView.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/29/24.
//

import SwiftUI
import RealityKit
import ARKit

struct NavigationView: View {
    @Environment(ViewModel.self) var viewModel

    var body: some View {
        @Bindable var viewModel = viewModel
        
        RealityView {
            content, attachments in
            let headAnchor = AnchorEntity(.head)

            if let navigationMenu = attachments.entity(for: viewModel.navigationAttachamentId) {
                navigationMenu.position = [-navigationMenu.attachment.bounds.extents.x / 2, 0.7, -1]
                
                headAnchor.addChild(navigationMenu)
            }
            
            content.add(headAnchor)
        }
    update: {_,_ in }
    attachments: {
        Attachment(id: viewModel.navigationAttachamentId) {
            VStack {
                Picker("Views", selection: $viewModel.currentView) {
                    ForEach(Views.allCases) { view in
                        Text(view.rawValue.capitalized)
                    }
                }
                .pickerStyle(.segmented)
            }
            .glassBackgroundEffect()
        }
        
    }
        
        
    }
}

#Preview {
    NavigationView()
}
