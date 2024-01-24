import RealityKit
import SwiftUI

// Ensure you register this component in your app’s delegate using:

public struct DragRotateComponent: Component {
    var dragGesture: EntityTargetValue<DragGesture.Value>?
    
    public init() {
    }
}
