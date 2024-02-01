//
//  OrbitComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 2/1/24.
//

import RealityKit
import SwiftUI
import Foundation

public struct OrbitComponent: Component {
    let orbits:ModelEntity
    var radius:Float = 0.5
    var roundTripTimeInSeconds:Float = 1.0
    var startTime:TimeInterval = Date().timeIntervalSince1970
    
    public init(orbits:ModelEntity) {
        self.orbits = orbits
    }
}
