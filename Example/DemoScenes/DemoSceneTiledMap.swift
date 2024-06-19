import SpriteKit
import GameplayKit
import MoreSpriteKit

class DemoSceneTiledMap: MSKTiledMapScene {

    var firstTile: MSKTile?
    let pathNode = SKNode()

    init(size: CGSize) {
        let zPositionPerNamedLayer = [
            "base": 1,
            "obstacles": 2
        ]
        super.init(size: size,
                   tiledMapName: "exampleTiled",
                   minimumCameraScale: 0.12,
                   maximumCameraScale: nil,
                   zPositionPerNamedLayer: zPositionPerNamedLayer)
        if let obstacleLayer = getLayer(name: "obstacles") {
            updatePathGraphUsing(layer: obstacleLayer, diagonalsAllowed: true)
        }
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
        if !isValidPathTile(tile: tile) {
            return
        }
        if let firstTile = firstTile {
            if let path = getPath(fromTile: firstTile, toTile: tile) {
                for point in path {
                    addIndicatorToPathNodeAt(tile: .init(column: Int(point.column), row: Int(point.row)))
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
