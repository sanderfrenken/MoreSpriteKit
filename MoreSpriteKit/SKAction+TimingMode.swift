import SpriteKit

public extension SKAction {
    
    func easeIn() -> SKAction {
        timingMode = .easeIn
        return self
    }

    func easeOut() -> SKAction {
        timingMode = .easeOut
        return self
    }

    func easeInEaseOut() -> SKAction {
        timingMode = .easeInEaseOut
        return self
    }
    
    func forever() -> SKAction {
        return SKAction.repeatForever(self)
    }
}
