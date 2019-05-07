import MoreSpriteKit
import SpriteKit

class DemoSceneArrowNode: DemoScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addArrowNodes()
    }

    private func addArrowNodes() {
        for _ in 0...10 {
            let arrow = MSKArrowNode(fillColor: randomColor, strokeColor: randomColor, lineWidth: 4, length: 100, tailWidth: 20, headWidth: 50, headLength: 30)
            arrow.position = randomPosition
            addChild(arrow)
        }
    }

    private var randomColor: UIColor {
        let randomColors: [UIColor] = [.blue, .red, .green, .yellow, .orange, .purple]

        return randomColors.randomElement()!
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
