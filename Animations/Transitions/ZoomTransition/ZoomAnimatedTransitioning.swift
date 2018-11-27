//
//  ZoomAnimatedTransitioning.swift
//  Animations
//
//  Created by AbsolutRenal on 26/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class ZoomAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
  private var fromVC: UIViewController
  private var toVC: UIViewController
  private var operation: UINavigationController.Operation
  
  init(from fromVC: UIViewController, to toVC: UIViewController, forOperation operation: UINavigationController.Operation) {
    self.fromVC = fromVC
    self.toVC = toVC
    self.operation = operation
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.5
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let toInitialAlpha: CGFloat = operation == .push
      ? 0.0
      : 1.0
    let fromInitialTransform: CGAffineTransform = operation == .push
      ? .identity
      : CGAffineTransform(scaleX: 0.6, y: 0.6).concatenating(CGAffineTransform(translationX: -80, y: 0))
    let toInitialTransform: CGAffineTransform = operation == .push
      ? CGAffineTransform(scaleX: 1.4, y: 1.4).concatenating(CGAffineTransform(translationX: 80, y: 0))
      : CGAffineTransform(scaleX: 0.6, y: 0.6).concatenating(CGAffineTransform(translationX: -80, y: 0))
    
    let fromFinalTransform: CGAffineTransform = operation == .push
      ? CGAffineTransform(scaleX: 0.6, y: 0.6).concatenating(CGAffineTransform(translationX: -80, y: 0))
      : CGAffineTransform(scaleX: 1.4, y: 1.4).concatenating(CGAffineTransform(translationX: 80, y: 0))
    let toFinalTransform: CGAffineTransform = operation == .push
      ? .identity
      : CGAffineTransform(scaleX: 1.4, y: 1.4).concatenating(CGAffineTransform(translationX: 80, y: 0))
    let fromFinalAlpha: CGFloat = operation == .push
      ? 1.0
      : 0.0
    let toFinalAlpha: CGFloat = operation == .push
      ? 1.0
      : 0.0
    
    toVC.view.frame = fromVC.view.frame
    fromVC.view.transform = fromInitialTransform
    toVC.view.transform = toInitialTransform
    toVC.view.alpha = toInitialAlpha
    
    transitionContext.containerView.addSubview(toVC.view)
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext),
                   delay: 0,
                   options: .curveEaseInOut,
                   animations: {
                    self.fromVC.view.transform = fromFinalTransform
                    self.fromVC.view.alpha = fromFinalAlpha
                    self.toVC.view.transform = toFinalTransform
                    self.toVC.view.alpha = toFinalAlpha
    },
                   completion: { _ in
                    transitionContext.completeTransition(transitionContext.transitionWasCancelled)
    })
  }
}
