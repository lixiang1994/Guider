# Guider

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

## [天朝子民](README_CN.md)

## Features

- [x] Support for custom area focus.
- [x] Support for custom view focus.
- [x] Support for custom mask graphic focus.
- [x] Support single-page multi-focus display.
- [x] Support multiple prompts for each focus.


## Installation

**CocoaPods - Podfile**

```ruby
source 'https://github.com/lixiang1994/Specs'

pod 'Guider'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/Guider"
```

## Usage

First make sure to import the framework:

```swift
import Guider
```

Here are some usage examples. All devices are also available as simulators:

Each page contains multiple items, each containing a focus and multiple prompts.

### Prepare

#### PageItem

```swift
var item = Guider.PageItem(.view(cell))
item = item.set(focus: {
    // focus click action
})
item = item.set(prompt: { (index) in
    // prompts click action
})
// add prompt
item = item.add(prompt: .image(image, .top(0.0)))
```

#### Page

```swift
Guider.Page(items: [item]) {
    // page click action
}
```

#### Start Guider
```swift
// The default guide page will be added to the current keyWindow
Guider.start([page]) {
    // Guided completion
}
```

#### Next page

```swift
Guider.next()
```

#### Stop Guider
```swift
Guider.stop()
```

### Focus Type

```swift
enum Focus {
    // UIView
    case view(UIView)
    case viewInsets(UIView, UIEdgeInsets)
    case viewInsetsCorner(UIView, UIEdgeInsets, cornerRadius: CGFloat)
    case viewInsetsMask(UIView, UIEdgeInsets, UIImage)
    // CGRect
    case rect(CGRect)
    case ellipse(CGRect)
    case mask(CGRect, UIImage)
    case rounded(CGRect, cornerRadius: CGFloat)
    case roundedCorners(CGRect, roundingCorners: UIRectCorner, cornerRadii: CGSize)
    case cirque(center: CGPoint, radius: CGFloat, startAngle: CGFloat, endAngle: CGFloat, clockwise: Bool)
}
```

### Prompt Type

```swift
enum Prompt {
    case image(UIImage, Position)
    case view(UIView, Position)
}
```

## Contributing

If you have the need for a specific feature that you want implemented or if you experienced a bug, please open an issue.
If you extended the functionality of Guider yourself and want others to use it too, please submit a pull request.


## License

Guider is under MIT license. See the [LICENSE](LICENSE) file for more info.

