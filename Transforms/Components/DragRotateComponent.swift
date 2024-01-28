import RealityKit
import SwiftUI

// Ensure you register this component in your app’s delegate using:

public struct DragRotateComponent: Component {
    var delta: simd_float3?
    
    public init() {
    }
}
