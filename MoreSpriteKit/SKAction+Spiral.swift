import SpriteKit

extension SKAction {
    // Adapted from
    // https://stackoverflow.com/questions/30427482/moving-a-skspritenode-in-a-downward-loop-using-swift/38235468
    public static func spiral(startRadius: CGFloat, endRadius: CGFloat, totalAngle: CGFloat, centerPoint: CGPoint, duration: TimeInterval) -> SKAction {

        let radiusPerRevolution = (endRadius - startRadius) / totalAngle
        let action = SKAction.customAction(withDuration: duration) { node, time in
            let theta = totalAngle * time / CGFloat(duration)
            let radius = startRadius + radiusPerRevolution * theta
            node.position = CGPoint(x: centerPoint.x + radius * cos(theta),
                                    y: centerPoint.y + radius * sin(theta))
        }

        return action
    }
}
