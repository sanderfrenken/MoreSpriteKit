[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat-square)](http://makeapullrequest.com)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)
![Platform support](https://img.shields.io/badge/platform-ios-lightgrey.svg?style=flat-square)

# MoreSpriteKit

This package offers additional node types and effects which you can use in combination with [SpriteKit](https://developer.apple.com/spritekit/). In addition it provides extensions to make complicated tasks a bit easier and improve the readability of your code.

All sources are written in Swift.

## Example usage

For examples using `MoreSpriteKit`, please refer to the demo project [MoreSpriteKitDemo](https://github.com/sanderfrenken/MoreSpriteKitDemo)

### MSKAnimatedLabel

`SKNode` that draws specified text over multiple lines, separated per `newLine` character.
The text typing can also be animated, meaning each character will be added after a specified interval, creating a typewriter effect.

Use public initializer:

```Swift
public init(text: String,
            horizontalAlignment: SKLabelHorizontalAlignmentMode = .center,
            durationPerCharacter: Double = 0.05,
            fontSize: CGFloat = 12,
            marginVertical: CGFloat = 15.0,
            fontColor: SKColor = .white,
            fontName: String = "Chalkduster",
            skipSpaces: Bool = true
            labelWidth: CGFloat = 0.0
            finishTypingOnTouch: Bool = false)
```
Where the text can be separated by new line characters to indicate start of new line.
Specify a specific `labelWidth` to wrap all text to a specific width. `MSKAnimatedLabel` will create new lines where necessary.
When the specified `labelWidth` is to small for a certain CharacterSequence, a fatal error is thrown.

When `durationPerCharacter <= 0.0`, all lines will be drawn immediately without any animation.
When `finishTypingOnTouch equals true`, all remaining lines will be drawn instantly without any animation when a user taps the label.

![Preview](/Previews/animated-label.gif)

### MSKEmitterLabel

`SKNode` that draws specified text using an emitter that follows the characters outlines, over a given duration.

Use public initializer:

```Swift
public init(text: String,
            font: UIFont,
            emitterName: String,
            marginHorizontal: CGFloat = 10.0,
            animationDuration: Double = 2.0,
            addEmitterInterval: Double = 0.1)
```


![Preview](/Previews/emitter-label.gif)

### SKAction+Spiral

Extension on SKAction allowing to create a spiraling movement.
Usage:

```Swift
SKAction.spiral(startRadius: radius,
                endRadius: radius-50,
                totalAngle: CGFloat(.pi * 2.0),
                centerPoint: .zero,
                duration: 1.5)
```
![Preview](/Previews/spiral-action.gif)

### SKAction+Shake

Extension on `SKAction` allowing to create a shake effect.
*NB preview as GIF is not very useful, for proper demonstration please see the example application.*

Usage:

```Swift
SKAction.shake(shakeDuration: 0.2,
               intensity: arc4random_uniform(40)+10,
               duration: 3)
```
![Preview](/Previews/shake-action.gif)


### SKShapeNode+Arrow
Extension on `SKShapeNode` allowing to create a node with an arrow shape.
Usage:

```Swift
let arrow = SKShapeNode(arrowWithFillColor: randomColor,
                        strokeColor: randomColor,
                        lineWidth: 4,
                        length: 100,
                        tailWidth: 20,
                        headWidth: 50,
                        headLength: 30)
```
![Preview](/Previews/skshapenode-arrow.png)

### SKTexture+RadialGradient
Extension on `SKTexture` allowing to create a texture with a radial gradiant. Could be used for example for range nodes, indicating a creatures attack range.
Usage:

```Swift
let radialGradientSize = CGSize(width: 150, height: 150)
let radialGradientColors = [UIColor.red, UIColor.blue, UIColor.green, UIColor.blue, UIColor.orange]
let radialGradientLocations: [CGFloat] = [0, 0.25, 0.45, 0.65, 1.0]

let radialTexture = SKTexture(radialGradientWithColors: radialGradientColors,
                              locations: radialGradientLocations,
                              size: radialGradientSize)

let radialNode = SKSpriteNode(texture: radialTexture)
```
![Preview](/Previews/sktexture-gradient.png)

### SKTexture+LinearGradient
Extension on `SKTexture` allowing to create a texture with a linear gradiant. Could be used for example for a healthbar.
Usage:

```Swift
let linearGradientSize = CGSize(width: 150, height: 30)
let linearGradientColors: [UIColor] = [.red, .yellow, .green, .yellow, .red]
let linearGradientLocations: [CGFloat] = [0, 0.35, 0.5, 0.65, 1.0]

let linearGradientTexture = SKTexture(linearGradientWithColors: linearGradientColors,
                                      locations: linearGradientLocations,
                                      size: linearGradientSize)

let gradientNode = SKSpriteNode(texture: linearGradientTexture)
```
![Preview](/Previews/sktexture-linearGradient.png)


### SKAction+TimingMode and Array+SKAction
- Public extensions on `SKAction` to add a `timingMode` or for example a `repeatForever` inline.
- Public extensions on `Array` to convert it inline to a `SKAction.group` or `SKAction.sequence`.

Usage:
```
let actions: [SKAction] = [.run { self.addEmitterLabel() }, .wait(forDuration: 10)]
run(actions.sequence().forever())
```

### Requirements

- iOS 10.3+
- Xcode 10.1+
- Swift 5+

### Installation

#### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding MoreSpriteKit as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift`.

```swift
dependencies: [
    .package(url: "https://github.com/sanderfrenken/MoreSpriteKit", .upToNextMajor(from: "1.0.0"))
]
```
#### Manually

If you prefer not to use any of the aforementioned dependency managers you can integrate the desired sources in your project manually, by adding the corresponding Swift files to your project.

### SwiftLint

We use Swiftlint from [Realm](https://realm.io/) to lint our code.
More info can be found on [SwiftLint](https://github.com/realm/SwiftLint).
Details about the specific settings for this project can be found in the `.swiftlint.yml` file.

### Other information

- If you think that something is missing or would like to propose new feature, please create an issue.
- Please feel free to ⭐️ the project. This gives confidence that you like it which stimulates further development and support 🤩

### Games using MoreSpriteKit
The following games are using MoreSpriteKit:

- [Battledom](https://sites.google.com/view/battledom/home)
- [Herodom](https://sites.google.com/view/herodom/home)
- [Numbed](https://apps.apple.com/nl/app/numbed/id841975891)
- [Connexx](https://apps.apple.com/nl/app/connexx/id1198001137)
- [SlippySlide](https://apps.apple.com/nl/app/slippy-slide/id911034356)

- Do you use MoreSpriteKit in any of your applications? Please extend this list by making a PR!

### License

[MIT](https://opensource.org/licenses/MIT)
