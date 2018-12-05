//
//  WWDCCustomTransitionInitialViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 04/12/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class WWDCCustomTransitionInitialViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet private weak var imageView: UIImageView!
  
  // MARK: - Properties
  private lazy var  tapGesture: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
  }()
  private let customTransitioningDelegate = WWDCTransitioningDelegate()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    imageView.image = UIImage(named: "LandscapePhoto")
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGesture)
    imageView.layer.cornerRadius = 12
    imageView.layer.masksToBounds = true
  }
  
  // MARK: - IBActions
  @objc private func didTapPhoto() {
    let controller = UIStoryboard(name: "WWDCCustomTransition", bundle: nil)
      .instantiateViewController(withIdentifier: "WWDCCustomTransitionFinalViewController")
    controller.transitioningDelegate = customTransitioningDelegate
    controller.modalPresentationStyle = .custom
    present(controller, animated: true, completion: nil)
  }
}

class WWDCTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return WWDCAnimatedTransitioning(isDismissing: false)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return WWDCAnimatedTransitioning(isDismissing: true)
  }
}

class WWDCAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
  // MARK: - Constants
  private enum Constants {
    static let duration: TimeInterval = 1
//    static let spring
//    static let dampling
  }
  
  // MARK: - Properties
  private let isDismissing: Bool
  
  // MARK: - LifeCycle
  init(isDismissing: Bool) {
    self.isDismissing = isDismissing
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
    guard let _ = transitionContext.viewController(forKey: .from) as? WWDCCustomTransitionInitialViewController,
      let toVC = transitionContext.viewController(forKey: .to) as? WWDCCustomTransitionFinalViewController else {
        return
    }
    toVC.view.frame = transitionContext.finalFrame(for: toVC)
    transitionContext.containerView.addSubview(toVC.view)
    toVC.animatePresentation(duration: transitionDuration(using: transitionContext)) {
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
  
  private func dismiss(using transitionContext: UIViewControllerContextTransitioning) {
    
  }
}
