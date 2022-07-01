import SpriteKit

let defaultTransition = SKTransition.fade(with: .black, duration: 1)

var randomPosition: CGPoint {
    let randomX = CGFloat.random(in: -100...100)
    let randomY = CGFloat.random(in: -150...150)
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
    case tiledMap
}

func addButton(buttonName: ButtonName, position: CGPoint, scene: SKScene) {
    let button = SKLabelNode(text: buttonName.rawValue)
    button.name = buttonName.rawValue
    button.fontSize = 20
    button.fontColor = .white
    button.position = position
    scene.addChild(button)
}
