import MoreSpriteKit
import SpriteKit

class DemoSceneAnimatedLabel: DemoScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addAnimatedLabel()
    }

    private func addAnimatedLabel() {
        let label = MSKAnimatedLabel(text: animatedLabelText)
        addChild(label)
        label.run(
            .repeatForever(
                .sequence([
                    .wait(forDuration: 10.0),
                    .run {
                        label.update(text: self.animatedLabelText)
                    }
                    ])
            )
        )
    }

    private var animatedLabelText: String {
        let sentence = "hello kind world..\n"
        var text = sentence
        for _ in 0..<10 {
            text.append(sentence)
        }
        return text
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
