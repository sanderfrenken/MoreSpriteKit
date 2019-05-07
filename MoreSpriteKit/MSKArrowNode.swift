import SpriteKit

public class MSKArrowNode: SKNode {

    public init(fillColor: SKColor, strokeColor: SKColor, lineWidth: CGFloat, length: CGFloat, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) {
        super.init()
        let arrowPath = UIBezierPath.arrow(from: .zero, to: CGPoint(x: 0, y: length), tailWidth: tailWidth, headWidth: headWidth, headLength: headLength).cgPath
        let arrowNode = SKShapeNode(path: arrowPath)
        arrowNode.fillColor = fillColor
        arrowNode.strokeColor = strokeColor
        arrowNode.lineWidth = lineWidth
        addChild(arrowNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
