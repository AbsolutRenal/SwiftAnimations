//
//  WWDCCustomTransitionInitialViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 04/12/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class WWDCCustomTransitionInitialViewController: UIViewController {
  // MARK: - Constants
  private enum Constants {
    static let cornerRadius: CGFloat = 12
  }
  
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
    imageView.layer.cornerRadius = Constants.cornerRadius
    imageView.layer.masksToBounds = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGesture)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    imageView.isUserInteractionEnabled = false
    imageView.removeGestureRecognizer(tapGesture)
  }
  
  // MARK: - IBActions
  @objc private func didTapPhoto() {
    let controller = UIStoryboard(name: "WWDCCustomTransition", bundle: nil)
      .instantiateViewController(withIdentifier: "WWDCCustomTransitionFinalViewController")
    controller.transitioningDelegate = customTransitioningDelegate
    controller.modalPresentationStyle = .custom
    present(controller, animated: true, completion: nil)
  }
  
  // MARK: - Public
  func getTransitionProperties() -> WWDCTransitionProperties {
    return WWDCTransitionProperties(cornerRadius: imageView.layer.cornerRadius,
                                    frame: view.convert(imageView.frame, to: UIApplication.shared.keyWindow))
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
struct WWDCTransitionProperties {
  let cornerRadius: CGFloat
  let frame: CGRect
}

struct WWDCTransitionAnimationOptions {
  let duration: TimeInterval
  let damping: CGFloat
  let initialVelocity: CGFloat
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class WWDCTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return WWDCAnimatedTransitioning(from: source, dismissing: false)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return nil
//    return WWDCAnimatedTransitioning(dismissing: true)
  }
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
class WWDCAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
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
    
  }
}
