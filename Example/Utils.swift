import SpriteKit

let defaultTransition = SKTransition.doorway(withDuration: 1)

var randomPosition: CGPoint {
    let randomX = CGFloat(arc4random_uniform(200))-100.0
    let randomY = CGFloat(arc4random_uniform(300))-50.0
    return CGPoint(x: randomX, y: randomY)
}

enum ButtonName: String {
    case back
    case radialGradient
    case animatedLabel
    case arrowNode
    case spiralAction
    case shakeAction
}

func addButton(buttonName: ButtonName, position: CGPoint, scene: SKScene) {
    let button = SKLabelNode(text: buttonName.rawValue)
    button.name = buttonName.rawValue
    button.fontSize = 20
    button.fontColor = .white
    button.position = position
    scene.addChild(button)
}
