import CoreGraphics

public extension CGPath {

    func getPaths() -> [CGPath] {
        var paths = [CGMutablePath]()
        paths.append(CGMutablePath())
        var currentPathIndex = 0
        self.forEach { element in
            if currentPathIndex > paths.count - 1 {
                paths.append(CGMutablePath())
            }
            switch element.type {
            case .moveToPoint:
                paths[currentPathIndex].move(to: element.points[0])
            case .addLineToPoint:
                paths[currentPathIndex].addLine(to: element.points[0])
            case .addQuadCurveToPoint:
                paths[currentPathIndex].addQuadCurve(to: element.points[0], control: element.points[1])
            case .addCurveToPoint:
                paths[currentPathIndex].addCurve(to: element.points[0], control1: element.points[1], control2: element.points[2])
            case .closeSubpath:
                paths[currentPathIndex].closeSubpath()
                currentPathIndex += 1
            default:
                break
            }
        }
        return paths
    }
}
