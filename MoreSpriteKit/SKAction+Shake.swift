import SpriteKit

public extension SKAction {

    static func shake(shakeDuration: Double = 0.20, intensity: UInt32 = 20, duration: Double) -> SKAction {

        let singleShakeDuration = shakeDuration/2

        let randomX = CGFloat(arc4random_uniform(intensity))-CGFloat(intensity)/2.0
        let randomY = CGFloat(arc4random_uniform(intensity))-CGFloat(intensity)/2.0

        let moveX = SKAction.move(by: CGVector(dx: randomX, dy: 0), duration: singleShakeDuration)
        let moveY = SKAction.move(by: CGVector(dx: 0, dy: randomY), duration: singleShakeDuration)

        let trembleX = SKAction.sequence([moveX, moveX.reversed()])
        let trembleY = SKAction.sequence([moveY, moveY.reversed()])

        let group = SKAction.group([trembleY, trembleX])
        let times = Int(duration / shakeDuration)

        return .sequence(Array(repeating: group, count: times))
    }
}
