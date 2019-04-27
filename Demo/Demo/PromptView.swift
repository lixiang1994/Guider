//
//  PromptView.swift
//  Demo
//
//  Created by 李响 on 2019/4/27.
//  Copyright © 2019 swift. All rights reserved.
//

import UIKit

class PromptView: UIView {
    
    lazy var titleLabel: UILabel = {
        $0.text = "Simple prompt"
        $0.textColor = .white
        $0.textAlignment = .center
        return $0
    }( UILabel() )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }
    
    private func setup() {
        addSubview(titleLabel)
    }
}
