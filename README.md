[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)

# MoreSpriteKit

This repository offers additional node types and effects which you can use in combination with [SpriteKit](https://developer.apple.com/spritekit/).  All sources are written in Swift. 

### MSKAnimatedLabel

SKNode that draws specified text over multiple lines, separated per newLine character. 
The text typing can also be animated, meaning each character will be added after a specified interval, creating a typewriter effect.

Use public initializer:
```
public init(text: String, 
            horizontalAlignment: SKLabelHorizontalAlignmentMode = .center, 
            durationPerCharacter: Double = 0.05, 
            fontSize: CGFloat = 12, 
            marginVertical: CGFloat = 15.0, 
            fontColor: SKColor = .white, 
            fontName: String = "Chalkduster", 
            skipSpaces: Bool = true)
```
Where the text can be separated by new line characters to indicate start of new line. 
When `durationPerCharacter <= 0.0`, all lines will be drawn immediately without any animation.

![Preview](https://github.com/sanderfrenken/MoreSpriteKit/blob/master/Previews/animated-label.gif)

### SKAction+Spiral

Extension on SKAction allowing to create a spiraling movement.
Usage:
```
SKAction.spiral(startRadius: radius,
                endRadius: radius-50,
                totalAngle: CGFloat(.pi * 2.0),
                centerPoint: .zero,
                duration: 1.5)
```
![Preview](https://github.com/sanderfrenken/MoreSpriteKit/blob/master/Previews/spiral-action.gif)

### SKAction+Shake

Extension on SKAction allowing to create a shake effect.
*NB preview as GIF is not very useful, for proper demonstration please see the example application.*

Usage:
```
SKAction.shake(shakeDuration: 0.2, 
               intensity: arc4random_uniform(40)+10, 
               duration: 3)
```
![Preview](https://github.com/sanderfrenken/MoreSpriteKit/blob/master/Previews/shake-action.gif)


### SKShapeNode+Arrow
Extension on SKShapeNode allowing to create a node with an arrow shape.
Usage:
```
let arrow = SKShapeNode(arrowWithFillColor: randomColor, 
                        strokeColor: randomColor, 
                        lineWidth: 4, 
                        length: 100, 
                        tailWidth: 20, 
                        headWidth: 50, 
                        headLength: 30)
```
![Preview](https://github.com/sanderfrenken/MoreSpriteKit/blob/master/Previews/skshapenode-arrow.png)

### SKTexture+RadialGradient
Extension on SKTexture allowing to create a texture with a radial gradiant. Could be used for example for range nodes, indicating a creatures attack range.
Usage:
```
let radialGradientSize = CGSize(width: 150, height: 150)
let radialGradientColors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.blue, UIColor.orange]
let radialGradientLocations: [CGFloat] = [0, 0.25, 0.45, 0.65, 1.0]

let radialTexture = SKTexture(radialGradientWithColors: radialGradientColors, 
                              locations: radialGradientLocations, 
                              size: radialGradientSize)

let radialNode = SKSpriteNode(texture: radialTexture)
```
![Preview](https://github.com/sanderfrenken/MoreSpriteKit/blob/master/Previews/sktexture-gradient.png)

### Requirements

- iOS 10.3+
- Xcode 10.1+
- Swift 5+

### Installation

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate MoreSpriteKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "sanderfrenken/MoreSpriteKit" "master"
```

#### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate the desired sources in your project manually, by adding the corresponding Swift files to your project.

### Demo app

This project contains an application target being a demo project that demonstrates the usage of all offered functionalities. 

### Other information

- If you think that something is missing or would like to propose new feature, please create an issue.
- Please feel free to ⭐️ the project. This gives confidence that you like it which stimulates further development and support 🤩
- Do you use MoreSpriteKit in any of your applications? Please let me know, I would love to see your creations!

### License

[MIT](https://opensource.org/licenses/MIT)
