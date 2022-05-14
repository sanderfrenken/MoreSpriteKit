import SpriteKit
import GameplayKit
import MoreSpriteKit

class DemoSceneTiledMap: SKScene {
    let map = SKNode()

    override func sceneDidLoad() {
        backgroundColor = .yellow
    }

    override func didMove(to view: SKView) {
        let parser = MSKTiledMapParser.init()
        let layers = parser.loadTilemap(filename: "testmap3")
        addChild(map)
        anchorPoint = .init(x: 0.5, y: 0.5)
        map.xScale = 0.9
        map.yScale = 0.9
        for layer in layers {
            map.addChild(layer)
        }
    }
}
