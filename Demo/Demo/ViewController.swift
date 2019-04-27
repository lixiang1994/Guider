//
//  ViewController.swift
//  Demo
//
//  Created by 李响 on 2019/4/19.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit
import Guider

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topButton: UIButton!
    
    private var list: [String] = [
        "高亮视图",
        "高亮视图+自定义边距",
        "高亮视图+自定义边距+圆角",
        "高亮视图+自定义边距+蒙版图形",
        "高亮视图+提示图片",
        "高亮视图+提示视图"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }

    private func setup() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func topAction(_ sender: Any) {
        
    }
}

extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension ViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "cell",
            for: indexPath
        )
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0: // 高亮视图
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            let item = Guider.PageItem(.view(cell)).set(focus: {
                print("focus tap")
                Guider.next()
                
            }).set(prompt: { (index) in
                print("prompt tap")
                Guider.next()
            })
            
            let page = Guider.Page(items: [item]) {
                print("page tap")
                Guider.next()
            }
            Guider.start([page]) {
                print("finish")
            }
            
        case 1: // 高亮视图+自定义边距
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            let focus = Guider.Focus.viewInsets(
                cell,
                .init(top: 10, left: 10, bottom: 10, right: 10)
            )
            
            let item = Guider.PageItem(focus).set(focus: {
                print("focus tap")
                Guider.next()
                
            }).set(prompt: { (index) in
                print("prompt tap")
                Guider.next()
            })
            
            let page = Guider.Page(items: [item]) {
                print("page tap")
                Guider.next()
            }
            Guider.start([page]) {
                print("finish")
            }
            
        case 2: // 高亮视图+自定义边距+圆角
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            let focus = Guider.Focus.viewInsetsCorner(cell, .zero, cornerRadius: 10)
            
            let item = Guider.PageItem(focus).set(focus: {
                print("focus tap")
                Guider.next()
                
            }).set(prompt: { (index) in
                print("prompt tap")
                Guider.next()
            })
            
            let page = Guider.Page(items: [item]) {
                print("page tap")
                Guider.next()
            }
            Guider.start([page]) {
                print("finish")
            }
            
        case 3: // 高亮视图+自定义边距+蒙版图形
            let focus = Guider.Focus.viewInsetsMask(topButton, .zero, #imageLiteral(resourceName: "gear"))
            
            let item = Guider.PageItem(focus).set(focus: {
                print("focus tap")
                Guider.next()
                
            }).set(prompt: { (index) in
                print("prompt tap")
                Guider.next()
            })
            
            let page = Guider.Page(items: [item]) {
                print("page tap")
                Guider.next()
            }
            Guider.start([page]) {
                print("finish")
            }
            
        case 4: // 高亮视图+提示图片
            let tempView = UIView(frame: CGRect(x: 60, y: 300, width: 130, height: 50))
            tempView.backgroundColor = #colorLiteral(red: 1, green: 0.3954350948, blue: 0.06483297795, alpha: 1)
            view.addSubview(tempView)
            
            let focus = Guider.Focus.viewInsetsCorner(
                tempView,
                .init(top: 10, left: 10, bottom: 10, right: 10),
                cornerRadius: 10
            )
            
            let item = Guider.PageItem(focus).set(focus: {
                print("focus tap")
                Guider.next()
                
            }).set(prompt: { (index) in
                print("prompt tap")
                Guider.next()
            }).add(prompt: .image(#imageLiteral(resourceName: "prompt_1"), .top(5)))
            
            let page = Guider.Page(items: [item]) {
                print("page tap")
                Guider.next()
            }
            Guider.start([page]) {
                print("finish")
                tempView.removeFromSuperview()
            }
        
        case 5: // 高亮视图+提示视图
            guard let cell = tableView.cellForRow(at: indexPath) else {
                return
            }
            
            let prompt = PromptView(frame: CGRect(x: 0, y: 0, width: 130, height: 50))
            
            let focus = Guider.Focus.viewInsetsCorner(cell, .zero, cornerRadius: 10)
            
            let item = Guider.PageItem(focus).set(focus: {
                print("focus tap")
                Guider.next()
                
            }).set(prompt: { (index) in
                print("prompt tap")
                Guider.next()
            }).add(prompt: .view(prompt, .bottom(5)))
            
            let page = Guider.Page(items: [item]) {
                print("page tap")
                Guider.next()
            }
            Guider.start([page]) {
                print("finish")
            }

        default:
            break
        }
    }
}

