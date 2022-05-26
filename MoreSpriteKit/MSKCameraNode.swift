import SpriteKit

public class MSKCameraNode: SKCameraNode {
    public let maximumCameraScale: CGFloat
    public let minimumCameraScale: CGFloat

    init(minimumCameraScale: CGFloat, maximumCameraScale: CGFloat) {
        self.minimumCameraScale = minimumCameraScale
        self.maximumCameraScale = maximumCameraScale
        super.init()
        let initialScale = minimumCameraScale + ((maximumCameraScale - minimumCameraScale)/2)
        setScale(initialScale)
    }

    public override func setScale(_ scale: CGFloat) {
        var cappedScale = scale
        if scale < minimumCameraScale {
            cappedScale = minimumCameraScale
        } else if scale > maximumCameraScale {
            cappedScale = maximumCameraScale
        }
        super.setScale(cappedScale)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
