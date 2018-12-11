//
//  WWDCAnimatedTransitioning.swift
//  Animations
//
//  Created by AbsolutRenal on 05/12/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class WWDCAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
  // MARK: - Constants
  private enum Constants {
    static let duration: TimeInterval = 0.8
    static let damping: CGFloat = 0.7
    static let initialVelocity: CGFloat = 1
  }
  
  // MARK: - Properties
  private let isDismissing: Bool
  private let source: UIViewController?
  
  // MARK: - LifeCycle
  init(from: UIViewController? = nil, dismissing: Bool) {
    isDismissing = dismissing
    source = from
  }
  
  // MARK: - UIViewControllerAnimatedTransitioning
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return Constants.duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    if isDismissing {
      dismiss(using: transitionContext)
    } else {
      present(using: transitionContext)
    }
  }
  
  // MARK: - Private
  private func present(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = source as? WWDCCustomTransitionInitialViewController,
      let toVC = transitionContext.viewController(forKey: .to) as? WWDCCustomTransitionFinalViewController else {
        return
    }
    toVC.configureTransition(with: fromVC.getTransitionProperties())
    transitionContext.containerView.addSubview(toVC.view)
    
    fromVC.selectedCell?.alpha = 0
    let fromAnimator = UIViewPropertyAnimator(duration: 0.2, curve: .easeOut) {
      fromVC.collectionView.alpha = 0
    }
    fromAnimator.addCompletion { _ in
      toVC.animatePresentation(options: WWDCTransitionAnimationOptions(duration: self.transitionDuration(using: transitionContext),
                                                                       damping: Constants.damping,
                                                                       initialVelocity: Constants.initialVelocity),
                               finalFrame: transitionContext.finalFrame(for: toVC)) {
                                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
      }
    }
    fromAnimator.startAnimation()
    
  }
  
  private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
    guard let fromVC = transitionContext.viewController(forKey: .from) as? WWDCCustomTransitionFinalViewController,
      let toVC = dismissingViewController(to: transitionContext.viewController(forKey: .to)) else {
        return
    }
    let toAnimator = UIViewPropertyAnimator(duration: 0.6, curve: .easeOut, animations: {
      toVC.collectionView.alpha = 1
    })
    toAnimator.addCompletion { _ in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    toAnimator.startAnimation()
    fromVC.animateDismissal(options: WWDCTransitionAnimationOptions(duration: transitionDuration(using: transitionContext),
                                                                    damping: Constants.damping,
                                                                    initialVelocity: Constants.initialVelocity)) {
                                                                      toVC.selectedCell?.alpha = 1
                                                                      
    }
  }
  
  private func dismissingViewController(to: UIViewController?) -> WWDCCustomTransitionInitialViewController? {
    return (to is UINavigationController)
    ? (to as! UINavigationController).viewControllers.last  as? WWDCCustomTransitionInitialViewController
    : to as? WWDCCustomTransitionInitialViewController
  }
}
