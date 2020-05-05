import MoreSpriteKit
import SpriteKit

class DemoSceneButton: DemoScene {

    let button = MSKButton(
        size: CGSize(width: 100, height: 50),
        defaultTexture: SKTexture(imageNamed: "defaultButtonTexture"),
        selectedTexture: SKTexture(imageNamed: "selectedButtonTexture"))

    override func didMove(to view: SKView) {
        super.didMove(to: view)

        button.onTouchesBegan = buttonOnTouchesBegan
        button.onTouchesEnded = buttonOnTouchesEnded

        addChild(button)
    }

    func buttonOnTouchesBegan() {
        print("buttonOnTouchesBegan")
    }

    func buttonOnTouchesEnded() {
        print("buttonOnTouchesEnded")
    }

    override func onBackPressed() {
        button.clearReferences()
        super.onBackPressed()
    }
}
