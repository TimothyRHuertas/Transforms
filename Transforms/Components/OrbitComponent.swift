//
//  OrbitComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 2/1/24.
//

import RealityKit
import SwiftUI
import Foundation

public enum OrbitComponentLayout : String, CaseIterable, Identifiable {
    case horizontal
    case verticle
    
    public var id: Self { self }
}

public struct OrbitComponent: Component {
    enum ValidationError: Error {
        case invalidTilt(message: String)
    }
    
    let orbits:ModelEntity
    var radius:Float
    var roundTripTimeInSeconds:Float
    var tiltAngleInRadians:Float
    var startTime:TimeInterval = Date().timeIntervalSince1970
    var layout:OrbitComponentLayout
    var clockwise:Bool
    
    public init(orbits:ModelEntity, radius:Float, tiltAngleInRadians:Float = 0, layout:OrbitComponentLayout = .horizontal, clockwise:Bool = true, roundTripTimeInSeconds:Float = 3) throws {
        if abs(tiltAngleInRadians) > .pi/4 {
            throw ValidationError.invalidTilt(message: "Error tiltAngleInRadians must be between -45 and 45. Try chaning the orientation to achieve your desired rotation.")
        }
        
        self.radius = radius
        self.orbits = orbits
        self.tiltAngleInRadians = tiltAngleInRadians
        self.layout = layout
        self.clockwise = clockwise
        self.roundTripTimeInSeconds = roundTripTimeInSeconds
    }
}
