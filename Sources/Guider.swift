//
//  Guider.swift
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

import Foundation
import UIKit

public enum Guider {
    private static var pages: [Page] = []
    private static var view: View?
    private static var completion: (() -> Void)?
    
    private static var index = 0
}

public extension Guider {
    
    /// 开始引导
    ///
    /// - Parameters:
    ///   - pages: 页面
    ///   - view: 所在视图, 为空则默认添加在keyWindow上
    ///   - completion: 引导完成回调
    static func start(_ pages: [Page],
                      view: UIView? = .none,
                      completion: (() -> Void)? = nil) {
        
        let window = UIApplication.shared.keyWindow
        guard let superView = view ?? window else { return }
        guard !pages.isEmpty else { return }
        
        superView.setNeedsLayout()
        superView.layoutIfNeeded()
        
        // 清理原有资源
        stop()
        
        let v = View(frame: superView.bounds, config: pages[index])
        superView.addSubview(v)
        
        self.view = v
        self.pages = pages
        self.completion = completion
    }
    
    /// 下一页
    static func next() {
        guard
            !pages.isEmpty,
            pages.count > index + 1,
            let superView = view?.superview else {
            stop()
            return
        }
        
        superView.setNeedsLayout()
        superView.layoutIfNeeded()
        
        view?.removeFromSuperview()
        
        index += 1
        let v = View(frame: superView.bounds, config: pages[index])
        superView.addSubview(v)
        view = v
    }
    
    /// 停止引导
    static func stop() {
        view?.removeFromSuperview()
        view = nil
        pages.removeAll()
        index = 0
        
        completion?()
    }
}

public struct Page {
    let items: [PageItem]
    let backgroundColor: UIColor
    let action: (()->Void)
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - items: 项
    ///   - backgroundColor: 页面背景颜色
    ///   - action: 页面点击事件
    public init(items: [PageItem],
                backgroundColor: UIColor = .init(white: 0, alpha: 0.3),
                action: @escaping (()->Void) = { Guider.next() }) {
        self.items = items
        self.backgroundColor = backgroundColor
        self.action = action
    }
}

public struct PageItem {
    let focus: Focus
    let isThrough: Bool
    
    var prompts: [Prompt]? = nil
    var focusAction: (()->Void) = { Guider.next() }
    var promptAction: ((Int)->Void) = { _ in Guider.next() }
    
    /// 初始化
    ///
    /// - Parameters:
    ///   - focus: 焦点
    ///   - isFocusThrough: 焦点是否点击穿透
    public init(_ focus: Focus, isThrough: Bool = false) {
        self.focus = focus
        self.isThrough = isThrough
    }
    
    /// 添加
    ///
    /// - Parameter prompt: 提示
    /// - Returns: PageItem
    @discardableResult
    public func add(prompt: Prompt) -> PageItem {
        var item = self
        var prompts = item.prompts ?? []
        prompts.append(prompt)
        item.prompts = prompts
        return item
    }
    
    /// 设置
    ///
    /// - Parameter action: 焦点点击事件
    /// - Returns: PageItem
    @discardableResult
    public func set(focus action: @escaping (()->Void)) -> PageItem {
        var item = self
        item.focusAction = action
        return item
    }
    
    /// 设置
    ///
    /// - Parameter action: 提示点击事件
    /// - Returns: PageItem
    @discardableResult
    public func set(prompt action: @escaping ((Int)->Void)) -> PageItem {
        var item = self
        item.promptAction = action
        return item
    }
}

/// 焦点
///
/// - view: 视图
/// - viewInsets: 视图 边距
/// - viewInsetsCorner: 视图 边距 圆角
/// - viewInsetsMask: 视图 边距 蒙版
/// - rect: 矩形
/// - ellipse: 椭圆
/// - mask: 蒙版
/// - rounded: 圆角矩形
/// - roundedCorners: 自定义圆角矩形
/// - cirque: 圆
public enum Focus {
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

/// 提示
///
/// - image: 图片
/// - view: 自定义视图
public enum Prompt {
    case image(UIImage, Position)
    case view(UIView, Position)
}

/// 位置
///
/// - top: 上 (间距)
/// - bottom: 下 (间距)
public enum Position {
    case top(CGFloat)
    case bottom(CGFloat)
}
