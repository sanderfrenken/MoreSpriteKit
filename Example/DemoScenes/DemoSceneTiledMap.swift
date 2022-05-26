import SpriteKit
import GameplayKit
import MoreSpriteKit

class DemoSceneTiledMap: MSKTiledMapScene {

    var firstTile: MSKTile?
    let pathNode = SKNode()

    init(size: CGSize) {
        let zPositionPerNamedLayer = [
            "Tile Layer 2": 1,
            "Tile Layer 1": 2
        ]
        super.init(size: size,
                   tiledMapName: "testmap3",
                   minimumCameraScale: 0.2,
                   maximumCameraScale: nil,
                   zPositionPerNamedLayer: zPositionPerNamedLayer)
        updatePathGraphUsing(layer: layers[1], obstacleProperty: "testProperty2", diagonalsAllowed: true)
        addChild(pathNode)
        pathNode.zPosition = 40
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        let touchLocationInScene = touches.first!.location(in: self)
        guard let tile = getTileFromPositionInScene(position: touchLocationInScene) else {
            return
        }
        if let firstTile = firstTile {
            if let path = getPath(fromTile: firstTile, toTile: tile) {
                for point in path {
                    addIndicatorToPathNodeAt(tile: .init(column: Int(point.x), row: Int(point.y)))
                }
            }
            self.firstTile = nil
        } else {
            pathNode.removeAllChildren()
            firstTile = tile
            addIndicatorToPathNodeAt(tile: tile)
        }
    }

    private func addIndicatorToPathNodeAt(tile: MSKTile) {
        let shapeNode = SKShapeNode(circleOfRadius: 16)
        shapeNode.fillColor = .yellow
        shapeNode.alpha = 0.6
        shapeNode.position = getPositionInSceneFromTile(tile: tile)
        pathNode.addChild(shapeNode)
    }
}
