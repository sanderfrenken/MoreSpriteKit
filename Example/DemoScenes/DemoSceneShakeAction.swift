import MoreSpriteKit
import SpriteKit

class DemoSceneShakeAction: DemoScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addChildNodes()
        run(.repeatForever(.sequence([
            .run {
                self.shakeChildren()
            },
            .wait(forDuration: 5)
        ])))
    }

    private func shakeChildren() {
        for child in self.children where child.name != ButtonName.back.rawValue {
            let shakeAction = SKAction.shake(shakeDuration: 0.2, intensity: arc4random_uniform(40)+10, duration: 3)
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
