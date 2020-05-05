import SpriteKit

class DemoScene: SKScene {

    override func didMove(to view: SKView) {
        backgroundColor = .black
        anchorPoint = CGPoint(x: 0.5, y: 0.5)
        addButton(buttonName: .back, position: CGPoint(x: -view.frame.width/2 + 50, y: view.frame.height/2 - 50), scene: self)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let nodeNameTouched = self.atPoint(touch.location(in: self)).name ?? ""
            if nodeNameTouched == ButtonName.back.rawValue {
                onBackPressed()
            }
        }
    }

    func onBackPressed() {
        guard let view = self.view else { return }
        view.presentScene(GameScene(size: view.frame.size), transition: defaultTransition)
    }
}
