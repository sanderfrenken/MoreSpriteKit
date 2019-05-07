import SpriteKit

extension SKShapeNode {

    public convenience init(arrowWithFillColor fillColor: SKColor, strokeColor: SKColor, lineWidth: CGFloat, length: CGFloat, tailWidth: CGFloat, headWidth: CGFloat, headLength: CGFloat) {
        let arrowPath = UIBezierPath.arrow(from: .zero, to: CGPoint(x: 0, y: length), tailWidth: tailWidth, headWidth: headWidth, headLength: headLength).cgPath
        self.init(path: arrowPath)
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.lineWidth = lineWidth
    }
}
