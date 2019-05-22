//
//  View.swift
//  ┌─┐      ┌───────┐ ┌───────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ │      │ └─────┐ │ └─────┐
//  │ │      │ ┌─────┘ │ ┌─────┘
//  │ └─────┐│ └─────┐ │ └─────┐
//  └───────┘└───────┘ └───────┘
//
//  Created by lee on 2018/6/4.
//  Copyright © 2018年 lee. All rights reserved.
//

import UIKit

class View: UIView {
    
    private let config: Page
    private var prompts: [[UIView]] = []
    
    init(frame: CGRect, config: Page) {
        self.config = config
        super.init(frame: frame)
        
        backgroundColor = .clear
        isOpaque = false
        
        addFocusViewObserver()
    }
    
    override func didMoveToSuperview() {
        superview?.addObserver(
            self,
            forKeyPath: "frame",
            options: .new,
            context: nil
        )
        superview?.addObserver(
            self,
            forKeyPath: "bounds",
            options: .new,
            context: nil
        )
        super.didMoveToSuperview()
    }
    
    override func removeFromSuperview() {
        superview?.removeObserver(self, forKeyPath: "frame")
        superview?.removeObserver(self, forKeyPath: "bounds")
        super.removeFromSuperview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        // 背景
        config.backgroundColor.set()
        context.addRect(rect)
        context.fillPath()
        context.saveGState()
        
        // 镂空
        context.setBlendMode(.clear)
        
        // 绘制
        for item in config.items {
            
            switch item.focus {
            case .view(let view):
                drawHandle(context, rect: convert(view, to: self))
                
            case .viewInsets(let view, let insets):
                drawHandle(context, rect: convert(view, to: self, insets: insets))
            
            case .viewInsetsCorner(let view, let insets, let cornerRadius):
                let r = convert(view, to: self, insets: insets)
                drawHandle(context, rect: r, cornerRadius: cornerRadius)
            
            case .viewInsetsMask(let view, let insets, let image):
                let r = convert(view, to: self, insets: insets)
                drawHandle(context, rect: rect, maskRect: r, maskImage: image)
                
            case .rect(let r):
                drawHandle(context, rect: r)
                
            case .mask(let r, let image):
                drawHandle(context, rect: rect, maskRect: r, maskImage: image)
                
            case .rounded(let r, let cornerRadius):
                drawHandle(context, rect: r, cornerRadius: cornerRadius)
                
            case .roundedCorners(let r, let roundingCorners, let cornerRadii):
                drawHandle(
                    context,
                    rect: r,
                    roundingCorners: roundingCorners,
                    cornerRadii: cornerRadii
                )
                
            case .ellipse(let r):
                drawHandle(context, ellipse: r)
                
            case .cirque(let center, let radius, let start, let end, let clockwise):
                drawHandle(
                    context,
                    center: center,
                    radius: radius,
                    startAngle: start,
                    endAngle: end,
                    clockwise: clockwise
                )
            }
        }
        
        // 设置提示
        setupPrompts()
    }
    
    deinit {
        // 移除KVO监听
        removeFocusViewObserver()
        print("View deinit")
    }
}

extension View {
    
    /// 矩形
    private func drawHandle(_ context: CGContext, rect: CGRect) {
        UIColor.black.set()
        context.addRect(rect)
        context.fillPath()
        context.saveGState()
    }
    
    /// 圆角矩形
    private func drawHandle(_ context: CGContext,
                            rect: CGRect,
                            cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
        UIColor.black.set()
        context.addPath(path.cgPath)
        context.fillPath()
        context.saveGState()
    }
    
    /// 圆角矩形
    private func drawHandle(_ context: CGContext,
                            rect: CGRect,
                            roundingCorners: UIRectCorner,
                            cornerRadii: CGSize) {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: roundingCorners,
            cornerRadii: cornerRadii
        )
        UIColor.black.set()
        context.addPath(path.cgPath)
        context.fillPath()
        context.saveGState()
    }
    
    /// 椭圆形
    private func drawHandle(_ context: CGContext, ellipse rect: CGRect) {
        UIColor.black.set()
        context.addEllipse(in: rect)
        context.fillPath()
        context.saveGState()
    }
    
    /// 蒙版图
    private func drawHandle(_ context: CGContext,
                            rect: CGRect,
                            maskRect: CGRect,
                            maskImage: UIImage) {
        guard let image = rotated(maskImage, degrees: 180).cgImage else { return }
        
        context.clip(to: maskRect, mask: image)
        UIColor.black.set()
        context.addRect(rect)
        context.fillPath()
        context.saveGState()
        context.resetClip()
    }
    
    /// 环形
    private func drawHandle(_ context: CGContext,
                            center: CGPoint,
                            radius: CGFloat,
                            startAngle: CGFloat,
                            endAngle: CGFloat,
                            clockwise: Bool) {
        UIColor.black.set()
        context.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: clockwise
        )
        context.fillPath()
        context.saveGState()
    }
}

extension View {
    
    private func setupPrompts() {
        
        for (i, item) in config.items.enumerated() {
            
            let rect = self.rect(item.focus)
            
            if prompts.count <= i {
                prompts.insert([], at: i)
            }
            
            var views = prompts[i]
            
            for (i, prompt) in (item.prompts ?? []).enumerated() {
                
                switch prompt {
                case .image(let image, let position):
                    
                    if views.count <= i {
                        let view = UIImageView(image: image)
                        view.isUserInteractionEnabled = true
                        addSubview(view)
                        
                        let tap = UITapGestureRecognizer(
                            target: self,
                            action: #selector(promptAtion)
                        )
                        view.addGestureRecognizer(tap)
                        
                        views.insert(view, at: i)
                    }
                    
                    let view = views[i]
                    
                    let ratio = image.size.height / image.size.width
                    let width = bounds.width
                    let height = width * ratio
                    let size = CGSize(width: width, height: height)
                    let origin = self.origin(
                        focus: rect,
                        prompt: size,
                        position: position
                    )
                    view.frame = CGRect(origin: origin, size: size)
                    
                case .view(let view, let position):
                    
                    if views.count <= i {
                        addSubview(view)
                        
                        let tap = UITapGestureRecognizer(
                            target: self,
                            action: #selector(promptAtion(_:))
                        )
                        view.addGestureRecognizer(tap)
                        
                        views.insert(view, at: i)
                    }
                    
                    let view = views[i]
                    
                    let size = view.bounds.size
                    let origin = self.origin(
                        focus: rect,
                        prompt: size,
                        position: position
                    )
                    view.frame = CGRect(origin: origin, size: size)
                }
            }
            
            prompts[i] = views
        }
    }
    
    private func rect(_ focus: Focus) -> CGRect {
        switch focus {
        case .view(let view):
            return convert(view, to: self)
            
        case .viewInsets(let view, let insets):
            return convert(view, to: self, insets: insets)
            
        case .viewInsetsCorner(let view, let insets, _):
            return convert(view, to: self, insets: insets)
            
        case .viewInsetsMask(let view, let insets, _):
            return convert(view, to: self, insets: insets)
            
        case .rect(let rect):
            return rect
            
        case .ellipse(let rect):
            return rect
            
        case .mask(let rect, _):
            return rect
            
        case .rounded(let rect, _):
            return rect
            
        case .roundedCorners(let rect, _, _):
            return rect
            
        case .cirque(let center, let radius, _, _, _):
            return CGRect(
                x: center.x + radius,
                y: center.y + radius,
                width: radius * 2,
                height: radius * 2
            )
        }
    }
}

extension View {
    
    private func addFocusViewObserver() {
        
        for item in config.items {
            switch item.focus {
            case .view(let view):
                addFrameObserver(view)
                
            case .viewInsets(let view, _):
                addFrameObserver(view)
            
            case .viewInsetsCorner(let view, _, _):
                addFrameObserver(view)
            
            default: break
            }
        }
    }
    
    private func removeFocusViewObserver() {
        for item in config.items {
            switch item.focus {
            case .view(let view):
                removeFrameObserver(view)
                
            case .viewInsets(let view, _):
                removeFrameObserver(view)
                
            case .viewInsetsCorner(let view, _, _):
                removeFrameObserver(view)
                
            default: break
            }
        }
    }
    
    private func addFrameObserver(_ view: UIView) {
        view.addObserver(self, forKeyPath: "frame", options: .new, context: nil)
        view.addObserver(self, forKeyPath: "bounds", options: .new, context: nil)
    }
    
    private func removeFrameObserver(_ view: UIView) {
        view.removeObserver(self, forKeyPath: "frame")
        view.removeObserver(self, forKeyPath: "bounds")
    }
    
    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        guard let object = object else { return }
        guard let keyPath = keyPath else { return }
        guard keyPath == "frame" || keyPath == "bounds" else { return }
        
        if
            let view = object as? UIView,
            let superview = superview, superview === view {
            // 父视图发生变化时 同步frame
            frame = superview.bounds
        }
        
        // 任何视图发生变化时 重新绘制
        setNeedsDisplay()
    }
}

extension View {
    
    /// touch事件
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let first = touches.first else { return }
        
        let point = first.location(in: self)
        let views = prompts.filter { $0.contains { $0.frame.contains(point) } }
        let focus = config.items.filter { rect($0.focus).contains(point) }
        if views.isEmpty, focus.isEmpty {
            config.action()
        } else {
            focus.forEach { $0.focusAction() }
        }
    }
    
    /// 响应范围
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let focus = config.items.filter { rect($0.focus).contains(point) }
        let rects = focus.map { rect($0.focus) }
        // 是否在焦点范围内
        if rects.contains(where: { $0.contains(point) }) {
            return !focus.contains(where: { $0.isThrough })
        }
        // 是否在当前视图范围内
        if bounds.contains(point) {
            return true
        }
        return false
    }
    
    /// 提示点击事件
    @objc private func promptAtion(_ gesture: UITapGestureRecognizer) {
        guard let view = gesture.view else { return }
        guard let i = prompts.firstIndex(where: { $0.contains(view) }) else { return }
        guard let index = prompts[i].firstIndex(where: { $0 == view }) else { return }
        let item = config.items[i]
        item.promptAction(index)
    }
}

extension View {
    
    private func rotated(_ image: UIImage, degrees: CGFloat) -> UIImage {
        guard let cgImage = image.cgImage else { return image }
        
        // CoreGraphics中原点位于左下角的坐标系与UIKit中的坐标系不同
        // 由于旋转相对与原点进行,所以需要将图片原点设置到旋转中心的位置
        // 先旋转到需要的度数, 再旋转180度将原点坐标处于左上角
        // 此时原点处于画布中心, 将图片绘制到向左向上一半的位置上(相对与原点在左下角的坐标系中, 向左向上则使用负数)
        // 最后获取绘制的图片
        
        let width = CGFloat(cgImage.width)
        let height = CGFloat(cgImage.height)
        
        let rotatedSize = CGSize(width: width, height: height)
        
        UIGraphicsBeginImageContext(rotatedSize)
        let context = UIGraphicsGetCurrentContext()
        context?.translateBy(x: width * 0.5, y: height * 0.5)
        context?.rotate(by: degrees * .pi / 180.0)
        context?.rotate(by: .pi)
        context?.draw(
            cgImage,
            in: CGRect(
                x: -width * 0.5,
                y: -height * 0.5,
                width: width,
                height: height
            )
        )
        let temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return temp ?? image
    }
    
    private func origin(focus rect: CGRect,
                        prompt size: CGSize,
                        position: Position) -> CGPoint {
        switch position {
        case .top(let offset):
            return CGPoint(x: 0, y: rect.minY - size.height - offset)
       
        case .bottom(let offset):
            return CGPoint(x: 0, y: rect.maxY + offset)
        }
    }
    
    private func convert(_ view: UIView, to: UIView, insets: UIEdgeInsets = .zero) -> CGRect {
        var rect = view.convert(view.bounds, to: self)
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += insets.left + insets.right
        rect.size.height += insets.top + insets.bottom
        return rect
    }
}
