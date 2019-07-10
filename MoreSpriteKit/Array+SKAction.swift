import SpriteKit

public extension Array where Iterator.Element == SKAction {

    func sequence() -> SKAction {
        return SKAction.sequence(self)
    }
    
    func group() -> SKAction {
        return SKAction.group(self)
    }
}
