import MoreSpriteKit
import SpriteKit

class DemoSceneShakeAction: DemoScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChildNodes()
        let actions: [SKAction] = [.run { self.shakeChildren() }, .wait(forDuration: 5)]
        run(actions.sequence().forever())
    }

    private func shakeChildren() {
        for child in self.children where child.name != ButtonName.back.rawValue {
            let shakeAction = SKAction.shake(shakeDuration: 0.2, intensity: .random(in: 10...50), duration: 3)
            child.run(shakeAction)
        }
    }

    private func addChildNodes() {
        for _ in 0..<10 {
            let childNode = SKShapeNode(circleOfRadius: 50)
            childNode.fillColor = .blue
            childNode.position = randomPosition
            addChild(childNode)
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
