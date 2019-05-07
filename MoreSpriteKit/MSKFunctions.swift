import CoreGraphics

public func pointOnCircle(angle: CGFloat, radius: CGFloat, center: CGPoint) -> CGPoint {
    return CGPoint(x: center.x + radius * cos(angle),
                   y: center.y + radius * sin(angle))
}
