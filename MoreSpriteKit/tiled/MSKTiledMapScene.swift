import SpriteKit
import GameplayKit

open class MSKTiledMapScene: SKScene {

    public let cameraNode: MSKCameraNode

    public let layers: [SKTileMapNode]
    public let tileGroups: [SKTileGroup]
    public let zPositionPerNamedLayer: [String: Int]

    public let mapNode = SKNode()
    private let zoomGestureRecogniser = UIPinchGestureRecognizer()
    private let baseTileMapNode: SKTileMapNode
    private var pathGraph: GKGridGraph<GKGridGraphNode>?

    public init(size: CGSize,
                tiledMapName: String,
                minimumCameraScale: CGFloat,
                maximumCameraScale: CGFloat?,
                zPositionPerNamedLayer: [String: Int],
                allowTileImagesCache: Bool = true) {
        let parsed = MSKTiledMapParser.init().loadTilemap(filename: tiledMapName, allowTileImagesCache: allowTileImagesCache)
        layers = parsed.layers
        tileGroups = parsed.tileGroups

        guard let firstLayer = layers.first else {
            fatalError("No layers parsed from map: \(tiledMapName)")
        }
        baseTileMapNode = firstLayer

        let maximumScalePossible = min(firstLayer.frame.width/size.width,
                                  firstLayer.frame.height/size.height) * 0.999
        let maximumScaleToInject: CGFloat
        if let maximumCameraScale = maximumCameraScale {
            if maximumCameraScale > maximumScalePossible {
                fatalError("Maxzoom provided impossible, max possible zoom: \(maximumScalePossible).")
            }
            maximumScaleToInject = maximumCameraScale
        } else {
            maximumScaleToInject = maximumScalePossible
        }
        var minimumCameraScaleToInject = minimumCameraScale
        if maximumScaleToInject < minimumCameraScaleToInject {
            minimumCameraScaleToInject = maximumScaleToInject
            log(logLevel: .warning, message: "minimumCameraScale is greater than maximumCameraScale")
        }

        self.cameraNode = MSKCameraNode(minimumCameraScale: minimumCameraScaleToInject,
                                        maximumCameraScale: maximumScaleToInject)
        self.zPositionPerNamedLayer = zPositionPerNamedLayer

        super.init(size: size)
        camera = cameraNode
        addChild(cameraNode)
    }

    open override func didMove(to view: SKView) {
        super.didMove(to: view)
        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        addChild(mapNode)
        for layer in layers {
            var found = false
            for zPositionLayer in zPositionPerNamedLayer where zPositionLayer.key == layer.name {
                layer.zPosition = CGFloat(zPositionLayer.value)
                found = true
            }
            if !found {
                log(logLevel: .warning, message: "No z-position provided for layer with name \(layer.name ?? "undefined")")
            }
            mapNode.addChild(layer)
        }

        zoomGestureRecogniser.addTarget(self, action: #selector(handleZoomFrom(sender:)))
        self.view?.addGestureRecognizer(zoomGestureRecogniser)

        setCameraConstraints()
    }

    public func updatePathGraphUsing(layer: SKTileMapNode, obstacleProperty: String, diagonalsAllowed: Bool) {
        let graph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0),
                                width: Int32(layer.numberOfColumns),
                                height: Int32(layer.numberOfRows),
                                diagonalsAllowed: diagonalsAllowed)
        var obstacles = [GKGridGraphNode]()
        for column in 0..<layer.numberOfColumns {
            for row in 0..<layer.numberOfRows {
                if let properties = getPropertiesForTileInLayer(layer: layer, tile: .init(column: column, row: row)),
                   let isObstacle = properties[obstacleProperty] as? Bool,
                   isObstacle {
                    obstacles.append(graph.node(atGridPosition: vector_int2(Int32(column), Int32(row)))!)
                }
            }
        }
        graph.remove(obstacles)
        pathGraph = graph
    }

    public func updatePathGraphUsing(layer: SKTileMapNode, obstacleProperty: String, diagonalsAllowed: Bool, removingTiles: [MSKTile]) {
        let graph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0),
                                width: Int32(layer.numberOfColumns),
                                height: Int32(layer.numberOfRows),
                                diagonalsAllowed: diagonalsAllowed)
        var obstacles = [GKGridGraphNode]()
        for column in 0..<layer.numberOfColumns {
            for row in 0..<layer.numberOfRows {
                if removingTiles.contains(.init(column: column, row: row)) {
                    obstacles.append(graph.node(atGridPosition: vector_int2(Int32(column), Int32(row)))!)
                } else if let properties = getPropertiesForTileInLayer(layer: layer, tile: .init(column: column, row: row)),
                          let isObstacle = properties[obstacleProperty] as? Bool,
                          isObstacle {
                    obstacles.append(graph.node(atGridPosition: vector_int2(Int32(column), Int32(row)))!)
                }
            }
        }
        graph.remove(obstacles)
        pathGraph = graph
    }

    public func updatePathGraphUsing(layer: SKTileMapNode, diagonalsAllowed: Bool) {
        let graph = GKGridGraph(fromGridStartingAt: vector_int2(0, 0),
                                width: Int32(layer.numberOfColumns),
                                height: Int32(layer.numberOfRows),
                                diagonalsAllowed: diagonalsAllowed)
        var obstacles = [GKGridGraphNode]()
        for column in 0..<layer.numberOfColumns {
            for row in 0..<layer.numberOfRows {
                if layer.tileGroup(atColumn: column, row: row) != nil {
                    obstacles.append(graph.node(atGridPosition: vector_int2(Int32(column), Int32(row)))!)
                }
            }
        }
        graph.remove(obstacles)
        pathGraph = graph
    }

    public func getPath(fromTile: MSKTile, toTile: MSKTile) -> [MSKTile]? {
        if !isValidTile(tile: fromTile) {
            log(logLevel: .warning, message: "Invalid tile provided as start for path")
        } else if !isValidTile(tile: toTile) {
            log(logLevel: .warning, message: "Invalid tile provided as end for path")
        }
        guard let pathGraph = pathGraph else {
            log(logLevel: .warning, message: "Pathgraph has not been initialized yet")
            return nil
        }
        guard let startNode = pathGraph.node(atGridPosition: vector_int2(Int32(fromTile.column), Int32(fromTile.row))) else {
            log(logLevel: .warning, message: "Invalid start position for finding a path")
            return nil
        }
        guard let endNode = pathGraph.node(atGridPosition: vector_int2(Int32(toTile.column), Int32(toTile.row))) else {
            log(logLevel: .warning, message: "Invalid end position for finding a path")
            return nil
        }
        let foundPath = pathGraph.findPath(from: startNode, to: endNode)
        if foundPath.isEmpty {
            log(logLevel: .warning, message: "Path could not be determined")
            return nil
        }
        var points = [MSKTile]()
        foundPath.forEach { pathNode in
            if let graphNode = pathNode as? GKGridGraphNode {
                points.append(.init(column: Int(graphNode.gridPosition.x),
                                    row: Int(graphNode.gridPosition.y)))
            }
        }
        return points
    }

    public func isValidTile(tile: MSKTile) -> Bool {
        if tile.row < 0 || tile.column < 0 {
            return false
        }
        return tile.row <= baseTileMapNode.numberOfRows-1 || tile.column <= baseTileMapNode.numberOfColumns-1
    }

    public func isValidPathTile(tile: MSKTile) -> Bool {
        guard isValidTile(tile: tile) else {
            return false
        }
        return pathGraph?.node(atGridPosition: .init(Int32(tile.column), Int32(tile.row))) != nil
    }

    public override func willMove(from view: SKView) {
        super.willMove(from: view)
        self.view?.removeGestureRecognizer(zoomGestureRecogniser)
    }

    public func getTileFromPositionInScene(position: CGPoint) -> MSKTile? {
        let pos = convert(position, to: baseTileMapNode)
        let column = baseTileMapNode.tileColumnIndex(fromPosition: pos)
        let row = baseTileMapNode.tileRowIndex(fromPosition: pos)
        let tile = MSKTile(column: column, row: row)
        return isValidTile(tile: tile) ? tile : nil
    }

    public func getLayer(name: String) -> SKTileMapNode? {
        if let layer = layers.first(where: { $0.name == name }) {
            return layer
        }
        return nil
    }

    public func scaleTo(scale: CGFloat) {
        cameraNode.setScale(scale)
        setCameraConstraints()
    }

    public func getPositionInSceneFromTile(tile: MSKTile) -> CGPoint {
        return baseTileMapNode.centerOfTile(atColumn: tile.column, row: tile.row)
    }

    public func getPositionsInSceneFromTiles(tiles: [MSKTile]) -> [CGPoint] {
        var points = [CGPoint]()
        for tile in tiles {
            points.append(getPositionInSceneFromTile(tile: tile))
        }
        return points
    }

    public func replaceTileGroupForTile(layer: SKTileMapNode, tile: MSKTile, tileGroup: SKTileGroup) {
        layer.setTileGroup(tileGroup, forColumn: tile.column, row: tile.row)
    }

    public func removeTileGroupForTile(layer: SKTileMapNode, tile: MSKTile, tileGroup: SKTileGroup) {
        layer.setTileGroup(nil, forColumn: tile.column, row: tile.row)
    }

    public func getPropertiesForTileInLayer(layer: SKTileMapNode, tile: MSKTile) -> NSMutableDictionary? {
        return layer.tileDefinition(atColumn: tile.column, row: tile.row)?.userData
    }

    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let currentPoint: CGPoint = touch.location(in: mapNode)
            let previousPoint: CGPoint = touch.previousLocation(in: mapNode)
            let deltaX = (currentPoint.x - previousPoint.x) * -1
            let deltaY = (currentPoint.y - previousPoint.y) * -1
            let moveAction = SKAction.moveBy(x: deltaX, y: deltaY, duration: 0.2)
            moveAction.timingMode = .easeOut
            cameraNode.run(moveAction)
        }
    }

    @objc func handleZoomFrom(sender: UIPinchGestureRecognizer) {
        if sender.numberOfTouches == 2 {
            let locationInView = sender.location(in: self.view)
            let location = self.convertPoint(fromView: locationInView)
            if sender.state == .changed {
                let convertedScale = 1/sender.scale
                let newScale = cameraNode.xScale*convertedScale
                cameraNode.setScale(newScale)
                setCameraConstraints()
                let locationAfterScale = self.convertPoint(fromView: locationInView)
                let locationDelta = CGPoint(x: location.x - locationAfterScale.x, y: location.y - locationAfterScale.y)
                cameraNode.position = .init(x: cameraNode.position.x + locationDelta.x, y: cameraNode.position.y + locationDelta.y)
                sender.scale = 1.0
            }
        }
    }

    private func setCameraConstraints() {
        let scaledSize = CGSize(width: size.width * cameraNode.xScale, height: size.height * cameraNode.yScale)
        let contentBounds = baseTileMapNode.frame
        let xInset = scaledSize.width / 2
        let yInset = scaledSize.height / 2

        let insetContentRect = contentBounds.insetBy(dx: xInset, dy: yInset)
        let xRange = SKRange(lowerLimit: insetContentRect.minX, upperLimit: insetContentRect.maxX)
        let yRange = SKRange(lowerLimit: insetContentRect.minY, upperLimit: insetContentRect.maxY)

        let levelEdgeConstraint = SKConstraint.positionX(xRange, y: yRange)
        levelEdgeConstraint.referenceNode = mapNode

        cameraNode.constraints = [levelEdgeConstraint]
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
