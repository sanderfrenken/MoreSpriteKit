import SpriteKit
import MoreSpriteKit

class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        backgroundColor = .black
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
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
                        let randomProperties = self.randomLabelProperties
                        label.update(text: self.animatedLabelText, horizontalAlignment: randomProperties.horizontalAlignment, durationPerCharacter: randomProperties.durationPerCharacter, fontSize: randomProperties.fontSize)
                    }
                    ])
            )
        )
    }

    private var randomLabelProperties: (horizontalAlignment: SKLabelHorizontalAlignmentMode, durationPerCharacter: Double, fontSize: CGFloat) {
        let randomAlignment: [SKLabelHorizontalAlignmentMode] = [.center, .right, .left]
        let randomDurations = [0.05, 0.025, 0.1]
        let randomFonts: [CGFloat] = [7.0, 10.0, 13.0]

        return(randomAlignment.randomElement()!, randomDurations.randomElement()!, randomFonts.randomElement()!)
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

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

    }

    override func update(_ currentTime: TimeInterval) {

    }
}
