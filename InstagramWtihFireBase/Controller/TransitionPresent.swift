//
//  TransitionPresent.swift
//  InstagramFirebase
//
//  Created by Fuad Hasan on 3/9/19.
//  Copyright © 2019 Fuad Hasan. All rights reserved.
//

import UIKit

class Transitionpresent : NSObject,UIViewControllerAnimatedTransitioning {
    

    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView

        guard let toView = transitionContext.view(forKey: .to) else {return}
        guard let fromView = transitionContext.view(forKey: .from) else {return}
        containerView.addSubview(toView)

         toView.frame = .init(x: -toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
        

        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {

            toView.frame = .init(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
            fromView.frame = .init(x: fromView.frame.width, y: 0, width: fromView.frame.width, height: fromView.frame.height)

        }) { (_) in
            transitionContext.completeTransition(true)
        }
    }
    


}
