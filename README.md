# MoreSpriteKit

This repository offers additional node types and effects which you can use in combination with **SpriteKit**.  All sources are written in Swift. 

## Features

- [x] Animated multiline label
![Preview](https://github.com/sanderfrenken/MoreSpriteKit/blob/master/Previews/animated-label.gif)
- [x] SKAction for spiraling movement
![Spiral](https://github.com/sanderfrenken/MoreSpriteKit/blob/master/Previews/spiral-action.gif)
- [x] SKAction for shaking nodes
![Shake](https://github.com/sanderfrenken/MoreSpriteKit/Previews/animated-label.gif)
- [x] SKShapeNode convenience init for arrow shape
- [x] SKTexture convenience init for radial gradient

### MSKAnimatedLabel
SKNode that draws specified text over multiple lines, separated per newLine character. 
The text typing can also be animated, meaning each character will be added after a specified interval, creating a typewriter effect.

## Requirements

- iOS 10.0+
- Xcode 10.2+
- Swift 5+

## Installation

### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate MoreSpriteKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```
github "sanderfrenken/MoreSpriteKit" "master"
```

### Manually

If you prefer not to use any of the aforementioned dependency managers, you can integrate the desired sources in your project manually, by adding the corresponding Swift files to your project.

## Demo app

This project contains an application target being a demo project that demonstrates the usage of all offered functionalities. 

### Other information

- If you think that something is missing or would like to propose new feature, please create an issue.
- Please feel free to ⭐️ the project. This gives confidence that you like it which stimulates further development and support 🤩
- Do you use MoreSpriteKit in any of your applications? Please let me know, would love to see your creations!
