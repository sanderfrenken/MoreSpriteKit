import SpriteKit

public class MSKEmitterLabel: SKNode {

    private let text: String
    private let font: UIFont
    private let emitterName: String
    private let marginHorizontal: CGFloat
    private let marginVertical: CGFloat
    private let animationDuration: Double
    private let addEmitterInterval: Double

    private var _childEmitters = [SKEmitterNode]()

    private var _width: CGFloat = 0
    public var width: CGFloat {
        get { return _width }
    }

    public init(text: String, font: UIFont, emitterName: String, marginHorizontal: CGFloat = 10.0, marginVertical: CGFloat = 10.0, animationDuration: Double = 2.0, addEmitterInterval: Double = 0.1) {
        self.text = text
        self.font = font
        self.emitterName = emitterName
        self.marginHorizontal = marginHorizontal
        self.marginVertical = marginVertical
        self.animationDuration = animationDuration
        self.addEmitterInterval = addEmitterInterval

        super.init()
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        _childEmitters.removeAll()
        let addChildEmittersCount = Int(animationDuration/addEmitterInterval) > 0 ? Int(animationDuration/addEmitterInterval) : 0
        for (_, character) in text.enumerated() {
            guard let path = UIBezierPath.init(character: character, font: font) else { continue }
            let characterNode = SKNode()
            characterNode.position.x = _width
            addChild(characterNode)
            _width += marginHorizontal + path.bounds.width
            path.cgPath.getPaths().forEach { path in
                let drawingEmitter = getEmitter()
                characterNode.addChild(drawingEmitter)
                drawingEmitter.run(.sequence([
                    .follow(path, duration: animationDuration),
                    .run { drawingEmitter.particleBirthRate = 0 }
                ]))
                drawingEmitter.run(.repeat(.sequence([
                    .wait(forDuration: addEmitterInterval),
                    .run {
                        let childEmitter = self.getEmitter()
                        self._childEmitters.append(childEmitter)
                        childEmitter.position = drawingEmitter.position
                        characterNode.addChild(childEmitter)
                        }]
                    ), count: addChildEmittersCount))
            }
        }
    }

    public func fadeOutChildEmitters() {
        _childEmitters.forEach { emitter in
            let randomWait = 1/Double(arc4random_uniform(10)+1)
            emitter.run(.sequence([
                .wait(forDuration: randomWait),
                .run { emitter.particleBirthRate = 0 }
            ]))
        }
    }

    private func getEmitter() -> SKEmitterNode {
        guard let emitter = SKEmitterNode(fileNamed: emitterName) else {
            fatalError("ERROR: Emitter with name: \(emitterName) could not be created.")
        }
        return emitter
    }
}
