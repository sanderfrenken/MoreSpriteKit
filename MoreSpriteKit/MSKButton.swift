import SpriteKit

private enum MSKButtonState {
    case normal
    case selected
}
public class MSKButton: SKSpriteNode {

    private let defaultTexture: SKTexture
    private let selectedTexture: SKTexture?

    public var onTouchesBegan: (() -> Void)?
    public var onTouchesEnded: (() -> Void)?

    public init(size: CGSize,
                defaultTexture: SKTexture,
                selectedTexture: SKTexture?,
                text: String?) {
        self.defaultTexture = defaultTexture
        self.selectedTexture = selectedTexture
        super.init(texture: defaultTexture, color: .clear, size: size)
        isUserInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchButtonTexture(state: .selected)
        (onTouchesBegan ?? {})()
    }

    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchButtonTexture(state: .normal)
        (onTouchesEnded ?? {})()
    }

    public func clearReferences() {
        onTouchesBegan = nil
        onTouchesEnded = nil
    }

    private func switchButtonTexture(state: MSKButtonState) {
        if selectedTexture == nil {
            return
        }
        switch state {
        case .normal:
            texture = defaultTexture
        case .selected:
            texture = selectedTexture
        }
    }
}
