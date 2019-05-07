import SpriteKit

extension SKAction {
    // Adapted from
    // https://stackoverflow.com/questions/30427482/moving-a-skspritenode-in-a-downward-loop-using-swift/38235468
    public static func spiral(startRadius: CGFloat, endRadius: CGFloat, angle
        totalAngle: CGFloat, centerPoint: CGPoint, duration: TimeInterval) -> SKAction {

        let radiusPerRevolution = (endRadius - startRadius) / totalAngle
        let action = SKAction.customAction(withDuration: duration) { node, time in
            let θ = totalAngle * time / CGFloat(duration)
            let radius = startRadius + radiusPerRevolution * θ
            node.position = CGPoint(x: centerPoint.x + radius * cos(θ),
                                    y: centerPoint.y + radius * sin(θ))
        }

        return action
    }
}
