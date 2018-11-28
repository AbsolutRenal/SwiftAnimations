//
//  ZoomAnimatedTransitioning.swift
//  Animations
//
//  Created by AbsolutRenal on 26/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class ZoomAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
  // MARK: - Constants
  private enum Constants {
    static let offsetX: CGFloat = 80
    static let animDuration: TimeInterval = 0.5
    static let ease: UIViewAnimationOptions = .curveEaseInOut
    static let scaleOffset: CGFloat = 0.4
  }
  
  
  // MARK: - Properties
  private var operation: UINavigationController.Operation
  
  init(forOperation operation: UINavigationController.Operation) {
    self.operation = operation
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Constants.animDuration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from),
      let toVC = transitionContext.viewController(forKey: .to) else {
        return
    }
    
    let toInitialAlpha: CGFloat = operation == .push
      ? 0.0
      : 1.0
    let toInitialTransform: CGAffineTransform = operation == .push
      ? CGAffineTransform(scaleX: 1 + Constants.scaleOffset, y: 1 + Constants.scaleOffset)
        .concatenating(CGAffineTransform(translationX: Constants.offsetX, y: 0))
      : CGAffineTransform(scaleX: 1 - Constants.scaleOffset, y: 1 - Constants.scaleOffset)
        .concatenating(CGAffineTransform(translationX: -Constants.offsetX, y: 0))
    
    let fromFinalTransform: CGAffineTransform = operation == .push
      ? CGAffineTransform(scaleX: 1 - Constants.scaleOffset, y: 1 - Constants.scaleOffset)
        .concatenating(CGAffineTransform(translationX: -Constants.offsetX, y: 0))
      : CGAffineTransform(scaleX: 1 + Constants.scaleOffset, y: 1 + Constants.scaleOffset)
        .concatenating(CGAffineTransform(translationX: Constants.offsetX, y: 0))
    let fromFinalAlpha: CGFloat = operation == .push
      ? 1.0
      : 0.0
    
    switch operation {
    case .push: transitionContext.containerView.addSubview(toVC.view)
    case .pop: transitionContext.containerView.insertSubview(toVC.view, at: 0)
    default: break
    }
    
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
    toVC.view.transform = toInitialTransform
    toVC.view.alpha = toInitialAlpha
    transitionContext.containerView.layoutIfNeeded()
    
    UIView.animate(withDuration: transitionDuration(using: transitionContext),
                   delay: 0,
                   options: Constants.ease,
                   animations: {
                    fromVC.view.transform = fromFinalTransform
                    fromVC.view.alpha = fromFinalAlpha
                    toVC.view.transform = .identity
                    toVC.view.alpha = 1.0
    },
                   completion: { _ in
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    })
  }
}
