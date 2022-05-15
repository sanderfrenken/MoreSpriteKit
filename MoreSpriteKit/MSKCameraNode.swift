import SpriteKit

public class MSKCameraNode: SKCameraNode {
    let maxZoom: CGFloat
    let minZoom: CGFloat

    init(minZoom: CGFloat, maxZoom: CGFloat) {
        self.minZoom = minZoom
        self.maxZoom = maxZoom
        super.init()
    }

    public override func setScale(_ scale: CGFloat) {
        var cappedScale = scale
        if scale < minZoom {
            cappedScale = minZoom
        } else if scale > maxZoom {
            cappedScale = maxZoom
        }
        super.setScale(cappedScale)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
