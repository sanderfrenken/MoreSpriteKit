import UIKit
import SpriteKit
import MoreSpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let skView = self.view as? SKView else {
            fatalError("SKView could not be referenced")
        }

        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.preferredFramesPerSecond = 60
        skView.shouldCullNonVisibleNodes = true
        skView.ignoresSiblingOrder = true

        let scene: SKScene = GameScene(size: skView.bounds.size)
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
