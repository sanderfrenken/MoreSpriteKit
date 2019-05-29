import MoreSpriteKit
import SpriteKit

class DemoSceneEmitterLabel: DemoScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        run(.repeatForever(.sequence([
            .run { self.addEmitterLabel() },
            .wait(forDuration: 10)
        ])))
    }

    private func addEmitterLabel() {
        let emitterLabel = MSKEmitterLabel(text: "HELLO WORLD", font: UIFont.systemFont(ofSize: 50), emitterName: "emitterLabel", marginHorizontal: 10, animationDuration: 3.0)
        emitterLabel.position.x -= emitterLabel.width/2.0
        addChild(emitterLabel)

        run(.sequence([
            .wait(forDuration: 5),
            .run { emitterLabel.fadeOutChildEmitters() },
            .wait(forDuration: 5),
            .removeFromParent()
        ]))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
