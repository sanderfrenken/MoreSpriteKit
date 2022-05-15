import SpriteKit
import GameplayKit
import MoreSpriteKit

class DemoSceneTiledMap: MSKTiledMapScene {

    init(size: CGSize) {
        super.init(size: size, tiledMapName: "testmap3", minZoom: 0.2, maxZoom: 1)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
