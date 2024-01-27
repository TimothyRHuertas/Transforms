//
//  HunterHuntedComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/27/24.
//

import RealityKit


public struct HunterHuntedComponent: Component {
    var isHunter: Bool
    
    public init(isHunter:Bool) {
        self.isHunter = isHunter
    }
}
