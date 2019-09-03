//
//  VerticalStackView.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 16/8/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit

class VerticalStackView:UIStackView {
    
    init(views:[UIView],spacing:CGFloat){
        super.init(frame: .zero)
        self.spacing = spacing
        self.axis = .vertical
        
        views.forEach { (view) in
            self.addArrangedSubview(view)
        }
        
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
