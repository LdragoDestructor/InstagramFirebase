//
//  TransitionDismiss.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 3/9/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit

class TransitionDismiss:NSObject,UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard  let fromView = transitionContext.view(forKey: .from) else {return}
        guard let toview = transitionContext.view(forKey: .to) else {return}
        
        
        containerView.addSubview(toview)
        toview.frame = .init(x: toview.frame.width, y: 0, width: toview.frame.width, height: toview.frame.height)
        
        containerView.frame = .init(x: 0, y: 0, width: fromView.frame.width, height: fromView.frame.height)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            fromView.frame = .init(x: -fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)
            toview.frame = .init(x: 0, y: 0, width: toview.frame.width, height: toview.frame.height)
            
        },completion:{ (_) in
            transitionContext.completeTransition(true)
        })
        
        
    }
    
    
    
    
}
