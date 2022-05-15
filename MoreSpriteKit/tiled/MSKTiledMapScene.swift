import SpriteKit
import GameplayKit

open class MSKTiledMapScene: SKScene {

    let mapNode = SKNode()
    let layers: [SKTileMapNode]
    let tiledMapName: String

    let baseTileMapNode: SKTileMapNode

    public let cameraNode: MSKCameraNode
    private let zoomGestureRecogniser = UIPinchGestureRecognizer()

    public init(size: CGSize,
                tiledMapName: String,
                minZoom: CGFloat,
                maxZoom: CGFloat) {
        self.tiledMapName = tiledMapName
        self.cameraNode = MSKCameraNode(minZoom: minZoom, maxZoom: maxZoom)

        let parser = MSKTiledMapParser.init()
        layers = parser.loadTilemap(filename: tiledMapName)

        guard let firstLayer = layers.first else {
            fatalError("No layers parsed from map: \(tiledMapName)")
        }
        baseTileMapNode = firstLayer
        super.init(size: size)
    }

    open override func didMove(to view: SKView) {
        super.didMove(to: view)

        anchorPoint = CGPoint(x: 0.5, y: 0.5)

        addChild(mapNode)
        for layer in layers {
            mapNode.addChild(layer)
        }
        camera = cameraNode
        addChild(cameraNode)

        zoomGestureRecogniser.addTarget(self, action: #selector(handleZoomFrom(sender:)))
        self.view?.addGestureRecognizer(zoomGestureRecogniser)

        setCameraConstraints()
    }

    public override func willMove(from view: SKView) {
        super.willMove(from: view)
        self.view?.removeGestureRecognizer(zoomGestureRecogniser)
    }

    func getTileFromPositionInScene(position: CGPoint) -> MSKTile {
        let pos = convert(position, to: baseTileMapNode)
        let column = baseTileMapNode.tileColumnIndex(fromPosition: pos)
        let row = baseTileMapNode.tileRowIndex(fromPosition: pos)
        return .init(column: column, row: row)
    }

    func addNodeToTile(tile: MSKTile, node: SKNode) {
        let nodePosition = baseTileMapNode.centerOfTile(atColumn: tile.column, row: tile.row)
        node.position = nodePosition
        mapNode.addChild(node)
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

    public override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
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

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
