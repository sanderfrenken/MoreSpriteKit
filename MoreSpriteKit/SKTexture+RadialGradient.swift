import SpriteKit

extension SKTexture {

    public convenience init(radialGradientWithColors colors: [UIColor], locations: [CGFloat], size: CGSize) {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { (context) in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let cgColors = colors.map({ $0.cgColor }) as CFArray

            guard let gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors, locations: UnsafePointer<CGFloat>(locations)) else {
                fatalError("Failed creating gradient.")
            }

            let radius = max(size.width, size.height) / 2.0
            let midPoint = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
            context.cgContext.drawRadialGradient(gradient, startCenter: midPoint, startRadius: 0, endCenter: midPoint, endRadius: radius, options: [])
        }

        self.init(image: image)
    }
}
