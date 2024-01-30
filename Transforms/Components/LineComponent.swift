//
//  LineComponent.swift
//  Transforms
//
//  Created by Timothy Huertas on 1/30/24.
//

import RealityKit


public struct LineComponent: Component {
    var from: simd_float3
    var to: simd_float3
    
    public init(from:simd_float3, to: simd_float3) {
        self.from = from
        self.to = to
    }
}
