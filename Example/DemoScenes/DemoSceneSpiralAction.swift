import MoreSpriteKit
import SpriteKit

class DemoSceneSpiralAction: DemoScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        run(.repeatForever(.sequence([
            .run {
                self.addSpiralNode()
            },
            .wait(forDuration: 8)]
        )))
        addSpiralNode()
    }

    private func addSpiralNode() {
        guard let emitter = SKEmitterNode(fileNamed: "spiralParticle") else { return }
        emitter.targetNode = self
        var radius: CGFloat = 250
        for idx in 0...4 {

            let spiralFor = SKAction.spiral(startRadius: radius,
                                            endRadius: radius-50,
                                            totalAngle: CGFloat(.pi * 2.0),
                                            centerPoint: .zero,
                                            duration: 1.5)
            emitter.run(.sequence([.wait(forDuration: 1.5 * Double(idx)), spiralFor]))
            radius -= 50
        }
        addChild(emitter)
        cleanUpEmitter(emitter: emitter)
    }

    private func cleanUpEmitter(emitter: SKEmitterNode) {
        emitter.run(.sequence([
            .wait(forDuration: 10),
            .run {
                emitter.particleBirthRate = 0
            },
            .wait(forDuration: 2),
            .removeFromParent()
        ]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
