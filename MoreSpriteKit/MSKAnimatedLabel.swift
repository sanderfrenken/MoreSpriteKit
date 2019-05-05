import Foundation
import SpriteKit

public class MSKAnimatedLabel: SKNode {

    private let timerActionKey = "timerActionKey"

    private var horizontalAlignment: SKLabelHorizontalAlignmentMode
    private var durationPerCharacter: Double
    private var fontSize: CGFloat
    private var fontColor: SKColor
    private var fontName: String
    private var marginVertical: CGFloat

    private var labels = [SKLabelNode]()
    private var lines: [String]?
    private var currentLineNumber = 0
    private var currentPositionOnLine = 0

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    public init(text: String, horizontalAlignment: SKLabelHorizontalAlignmentMode = .center, durationPerCharacter: Double = 0.05, fontSize: CGFloat = 12, marginVertical: CGFloat = 15.0, fontColor: SKColor = .white, fontName: String = "Chalkduster") {
        self.lines = text.components(separatedBy: CharacterSet.newlines)
        self.horizontalAlignment = horizontalAlignment
        self.durationPerCharacter = durationPerCharacter
        self.fontSize = fontSize
        self.marginVertical = marginVertical
        self.fontName = fontName
        self.fontColor = fontColor
        super.init()
        startTyping()
    }

    public func update(text: String, horizontalAlignment: SKLabelHorizontalAlignmentMode = .center, durationPerCharacter: Double = 0.05, fontSize: CGFloat = 12, marginVertical: CGFloat = 15.0, fontColor: SKColor = .white, fontName: String = "Chalkduster") {
        removeTimer()
        self.lines = text.components(separatedBy: CharacterSet.newlines)
        self.horizontalAlignment = horizontalAlignment
        self.durationPerCharacter = durationPerCharacter
        self.fontSize = fontSize
        self.marginVertical = marginVertical
        self.fontName = fontName
        self.fontColor = fontColor
        startTyping()
    }

    private func startTyping() {
        currentLineNumber = 0
        currentPositionOnLine = 0
        createLabels()

        run(.repeatForever(.sequence([
            .wait(forDuration: durationPerCharacter),
            .run { self.typeText()}
            ])), withKey: timerActionKey)
    }

    private func createLabels() {
        resetLabels()

        lines?.forEach { _ in
            let label = SKLabelNode(fontNamed: fontName)
            label.horizontalAlignmentMode = horizontalAlignment
            label.fontSize = fontSize
            label.fontColor = fontColor
            label.text = ""
            labels.append(label)
        }

        var idx = 0
        labels.forEach { label in
            label.position.y -= marginVertical*CGFloat(idx)
            addChild(label)
            idx += 1
        }
    }

    private func resetLabels() {
        labels.forEach { label in
            label.removeFromParent()
        }
        labels = [SKLabelNode]()
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
}
