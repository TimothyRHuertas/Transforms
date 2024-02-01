//
//  ViewModel.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/29/24.
//
import SwiftUI

enum Views: String, CaseIterable, Identifiable {
    case proximity
    case position
    case chase
    case connect
    case rotateToMatchFloor
   
    var id: Self { self }
}

@Observable
class ViewModel {
    let navigationAttachamentId = "navigation"
    var currentView:Views = .proximity
}
