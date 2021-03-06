import SpriteKit

let defaultTransition = SKTransition.fade(with: .black, duration: 1)

var randomPosition: CGPoint {
    let randomX = CGFloat(arc4random_uniform(200))-100.0
    let randomY = CGFloat(arc4random_uniform(300))-150.0
    return CGPoint(x: randomX, y: randomY)
}

enum ButtonName: String {
    case back
    case button
    case radialGradient
    case animatedLabel
    case arrowNode
    case spiralAction
    case shakeAction
    case emitterLabel
}

func addButton(buttonName: ButtonName, position: CGPoint, scene: SKScene) {
    let button = SKLabelNode(text: buttonName.rawValue)
    button.name = buttonName.rawValue
    button.fontSize = 20
    button.fontColor = .white
    button.position = position
    scene.addChild(button)
}
