import SpriteKit

private enum MSKButtonState {
    case normal
    case selected
}

open class MSKButton: SKSpriteNode {

    private let defaultTexture: SKTexture
    private let selectedTexture: SKTexture?
    private let touchSize: CGSize?

    public var onTouchesBegan: (() -> Void)?
    public var onTouchesEnded: (() -> Void)?
    public var unclickOnTouchesEnded = true

    public init(size: CGSize,
                defaultTexture: SKTexture,
                selectedTexture: SKTexture? = nil,
                touchSize: CGSize? = nil) {
        self.defaultTexture = defaultTexture
        self.selectedTexture = selectedTexture
        self.touchSize = touchSize
        super.init(texture: defaultTexture, color: .clear, size: size)
        addAdditionalTouchNode()
        isUserInteractionEnabled = true
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        switchButtonTexture(state: .selected)
        (onTouchesBegan ?? {})()
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if unclickOnTouchesEnded {
            switchButtonTexture(state: .normal)
        }
        (onTouchesEnded ?? {})()
    }

    public func clearReferences() {
        onTouchesBegan = nil
        onTouchesEnded = nil
    }

    public func unclick() {
        texture = defaultTexture
    }

    public func click() {
        guard let selectedTexture else {
            return
        }
        texture = selectedTexture
    }

    private func addAdditionalTouchNode() {
        guard let touchSize = touchSize else { return }
        addChild(SKSpriteNode(texture: nil, color: .clear, size: touchSize))
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
