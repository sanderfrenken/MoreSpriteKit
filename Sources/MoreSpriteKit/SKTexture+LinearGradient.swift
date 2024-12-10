import SpriteKit

public extension SKTexture {

    convenience init(linearGradientWithColors colors: [UIColor], locations: [CGFloat], size: CGSize) {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { context in
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let cgColors = colors.map({ $0.cgColor }) as CFArray

            var gradient: CGGradient?
            locations.withUnsafeBufferPointer { locationBuffer in
                gradient = CGGradient(colorsSpace: colorSpace, colors: cgColors as CFArray, locations: locationBuffer.baseAddress)
            }
            guard let gradient else {
                fatalError("Failed creating gradient.")
            }

            context.cgContext.drawLinearGradient(gradient, start: .init(x: 0, y: size.height), end: .init(x: size.width, y: size.height), options: [])
        }
        self.init(image: image)
    }
}
