# Guider

![Swift](https://img.shields.io/badge/Swift-5.0-orange.svg)

## [天朝子民](README_CN.md)

## 特性

- [x] 支持自定义区域焦点.
- [x] 支持自定义视图焦点.
- [x] 支持自定义蒙版图形焦点.
- [x] 支持单页面多焦点显示.
- [x] 支持单焦点多提示显示.


## 安装

**CocoaPods - Podfile**

```ruby
source 'https://github.com/lixiang1994/Specs'

pod 'Guider'
```

**Carthage - Cartfile**

```ruby
github "lixiang1994/Guider"
```

## 使用

首先导入framework:

```swift
import Guider
```

以下是一些使用示例. 可以在所有设备中使用也可用作模拟器:

每个页面可包含多个项, 每个项包含一个焦点和多个提示.

### 准备

#### 页面项

```swift
var item = Guider.PageItem(.view(cell))
item = item.set(focus: {
    // 焦点点击事件
})
item = item.set(prompt: { (index) in
    // 提示点击事件 多个提示可以通过 index 区分
})
// 添加提示
item = item.add(prompt: .image(image, .top(0.0)))
```

#### 页面

```swift
Guider.Page(items: [item]) {
    // 页面点击事件
}
```

#### 开始引导
```swift
// 默认情况引导页面会添加到当前keyWindow上 也可以通过设置view: 参数来指定添加的视图
Guider.Provider.start([page]) {
    // 引导完成
}
```

#### 下一页

```swift
Guider.Provider.next()
```

#### 停止引导
```swift
Guider.Provider.stop()
```

### 焦点类型

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

### 提示类型

```swift
enum Prompt {
    case image(UIImage, Position)
    case view(UIView, Position)
}
```

## 贡献

如果你需要实现特定功能或遇到错误，请打开issue。 如果你自己扩展了Guider的功能并希望其他人也使用它，请提交拉取请求。


## 许可协议

Guider 使用 MIT 协议。 有关更多信息，请参阅 [LICENSE](LICENSE) 文件。
