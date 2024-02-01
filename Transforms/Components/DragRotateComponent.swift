import RealityKit
import SwiftUI

// Ensure you register this component in your app’s delegate using:

public struct DragRotateComponent: Component {
    var previousGesture: EntityTargetValue<DragGesture.Value>?
    var currentGesture: EntityTargetValue<DragGesture.Value>?

    public init(){
    }
}
