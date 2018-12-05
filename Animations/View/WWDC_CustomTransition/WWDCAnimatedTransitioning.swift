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
    
    toVC.animatePresentation(options: WWDCTransitionAnimationOptions(duration: transitionDuration(using: transitionContext),
                                                                     damping: Constants.damping,
                                                                     initialVelocity: Constants.initialVelocity),
                             finalFrame: transitionContext.finalFrame(for: toVC)) {
                              transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
  
  private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
    //TODO: to implement
  }
}
