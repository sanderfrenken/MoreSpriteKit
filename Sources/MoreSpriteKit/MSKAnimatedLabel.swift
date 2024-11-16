import SpriteKit

public class MSKAnimatedLabel: SKNode {

    private let timerActionKey = "timerActionKey"

    private let horizontalAlignment: SKLabelHorizontalAlignmentMode
    private let durationPerCharacter: Double
    private let fontSize: CGFloat
    private let fontColor: SKColor
    private let fontName: String
    private let marginVertical: CGFloat
    private let skipSpaces: Bool
    private let labelWidth: CGFloat
    private let finishTypingOnTouch: Bool

    private var labels = [SKLabelNode]()
    private var lines: [String]?
    private var currentLineNumber = 0
    private var currentPositionOnLine = 0

    public init(text: String, horizontalAlignment: SKLabelHorizontalAlignmentMode = .center, durationPerCharacter: Double = 0.05, fontSize: CGFloat = 12, marginVertical: CGFloat = 15.0, fontColor: SKColor = .white, fontName: String = "Chalkduster", skipSpaces: Bool = true, labelWidth: CGFloat = 0.0, finishTypingOnTouch: Bool = false) {
        self.lines = text.components(separatedBy: CharacterSet.newlines)
        self.horizontalAlignment = horizontalAlignment
        self.durationPerCharacter = durationPerCharacter
        self.fontSize = fontSize
        self.marginVertical = marginVertical
        self.fontName = fontName
        self.fontColor = fontColor
        self.skipSpaces = skipSpaces
        self.labelWidth = labelWidth
        self.finishTypingOnTouch = finishTypingOnTouch
        super.init()
        setup()
    }

    func defineUserInteraction() {
        if finishTypingOnTouch {
            isUserInteractionEnabled = true
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public func update(text: String) {
        removeTimer()
        self.lines = text.components(separatedBy: .newlines)
        setup()
    }

    private func setup() {
        defineUserInteraction()
        createLabels()
        if shouldAnimate {
            startTyping()
        }
    }

    private func createLabels(forceNoAnimation: Bool = false) {
        resetLabels()

        if labelWidth > 0 {
            wrapLinesToLabelWidth()
        }

        lines?.forEach { line in
            let label = SKLabelNode(fontNamed: fontName)
            label.horizontalAlignmentMode = horizontalAlignment
            label.fontSize = fontSize
            label.fontColor = fontColor
            if shouldAnimate && !forceNoAnimation {
                label.text = ""
            } else {
                label.text = line
            }
            labels.append(label)
        }

        var idx = 0
        labels.forEach { label in
            label.position.y -= marginVertical*CGFloat(idx)
            addChild(label)
            idx += 1
        }
        addTouchNodeForAutocomplete()
    }

    private func addTouchNodeForAutocomplete() {
        let touchNode = SKSpriteNode(color: .clear,
                                     size: .init(width: labelWidth,
                                                 height: CGFloat(labels.count) * marginVertical))
        touchNode.position.y -= touchNode.frame.height/2
        addChild(touchNode)
    }

    private func wrapLinesToLabelWidth() {
        var linesWrapped = [String]()
        lines?.forEach { line in
            linesWrapped.append(contentsOf: wrapLine(line: line))
        }
        self.lines = linesWrapped
    }

    private func wrapLine(line: String) -> [String] {
        let words = line.components(separatedBy: " ")
        let label = SKLabelNode(fontNamed: fontName)
        label.horizontalAlignmentMode = horizontalAlignment
        label.fontSize = fontSize

        var lineWrapped = [String]()
        var currentLineContent = ""
        var nextLineContent = ""
        var idx = 0
        var didReachEnd = false

        while !didReachEnd {
            if currentLineContent != "" {
                nextLineContent += " "
            }
            nextLineContent += words[idx]
            label.text = nextLineContent
            if label.frame.width > labelWidth {
                if currentLineContent == "" {
                    fatalError("ERROR: LabelWidth to small")
                }
                lineWrapped.append(currentLineContent)
                currentLineContent = ""
                nextLineContent = ""
            } else {
                currentLineContent = nextLineContent
                idx+=1
                if idx >= words.count {
                    lineWrapped.append(currentLineContent)
                    didReachEnd = true
                }
            }
        }
        return lineWrapped
    }

    private func resetLabels() {
        labels.forEach { label in
            label.removeFromParent()
        }
        labels = [SKLabelNode]()
    }

    private var shouldAnimate: Bool {
        return durationPerCharacter > 0.0
    }

    private func startTyping() {
        currentLineNumber = 0
        currentPositionOnLine = 0

        run(.repeatForever(.sequence([
            .wait(forDuration: durationPerCharacter),
            .run { [weak self] in
                self?.typeText()
            } ])), withKey: timerActionKey)
    }

    private func typeText() {
        if shouldTypeText() {
            addNewCharacter()
        } else {
            removeTimer()
        }
    }

    private func shouldTypeText() -> Bool {
        if didFillLastLine {
            return false
        }
        if didReachEndOfLine {
            currentLineNumber += 1
            currentPositionOnLine = 0
            return shouldTypeText()
        }
        return true
    }

    private func addNewCharacter() {
        if let lines = lines {
            let currentLine = lines[currentLineNumber]
            let newCharacter = Array(currentLine)[currentPositionOnLine]
            labels[currentLineNumber].text! += String(newCharacter)
            currentPositionOnLine += 1
            if newCharacter == " " && skipSpaces {
                typeText()
            }
        }
    }

    private var didReachEndOfLine: Bool {
        if let lines = lines {
            return currentPositionOnLine >= lines[currentLineNumber].count
        }
        return true
    }

    private var didFillLastLine: Bool {
        if let lines = lines {
            return currentLineNumber >= lines.count
        }
        return true
    }

    private func removeTimer() {
        removeAction(forKey: timerActionKey)
    }

    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if finishTypingOnTouch {
            removeTimer()
            createLabels(forceNoAnimation: true)
        }
    }
}
