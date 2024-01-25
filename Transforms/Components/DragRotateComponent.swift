import RealityKit
import SwiftUI

// Ensure you register this component in your app’s delegate using:

public struct DragRotateComponent: Component {
    var dragGesture: EntityTargetValue<DragGesture.Value>?
    var baseYaw:Float = 0
    var basePitch:Float = 0
    
    public init() {
    }
}
