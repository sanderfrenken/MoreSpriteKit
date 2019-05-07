import MoreSpriteKit
import SpriteKit

class DemoSceneRadielGradient: DemoScene {

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        addRadielGradients()
    }

    private func addRadielGradients() {
        let radialGradientSize = CGSize(width: 150, height: 150)
        let radialGradientColors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.blue, UIColor.orange]
        let radialGradientLocations: [CGFloat] = [0, 0.25, 0.45, 0.65, 1.0]

        let radialTexture = SKTexture(radialGradientWithColors: radialGradientColors, locations: radialGradientLocations, size: radialGradientSize)

        let radialNode = SKSpriteNode(texture: radialTexture)
        addChild(radialNode)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }
}
