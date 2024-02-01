//
//  OrbitComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 2/1/24.
//

import RealityKit
import SwiftUI
import Foundation

public enum OrbitComponentLayout {
    case horizontal
    case verticle
}

public struct OrbitComponent: Component {
    enum ValidationError: Error {
        case invalidTilt(message: String)
    }
    
    let orbits:ModelEntity
    var radius:Float = 0.5
    var roundTripTimeInSeconds:Float = 1.5
    var tiltAngleInRadians:Float
    var startTime:TimeInterval = Date().timeIntervalSince1970
    var layout = OrbitComponentLayout.horizontal
    
    public init(orbits:ModelEntity, tiltAngleInRadians:Float = 0) throws {
        if abs(tiltAngleInRadians) > .pi/4 {
            throw ValidationError.invalidTilt(message: "Error tiltAngleInRadians must be between -45 and 45. Try chaning the orientation to achieve your desired rotation.")
        }
        
        self.orbits = orbits
        self.tiltAngleInRadians = tiltAngleInRadians
    }
}
