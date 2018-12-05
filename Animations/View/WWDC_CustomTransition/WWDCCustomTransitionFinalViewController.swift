//
//  WWDCCustomTransitionFinalViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 04/12/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class WWDCCustomTransitionFinalViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var contentView: UIView!
  
  // MARK: - Properties
  private lazy var  tapGesture: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
  }()
  private var transitionProperties: WWDCTransitionProperties?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    imageView.image = UIImage(named: "LandscapePhoto")
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
    dismiss(animated: true, completion: nil)
  }
  
  // MARK: - Public
  func configureTransition(with properties: WWDCTransitionProperties) {
    transitionProperties = properties
    scrollView.isScrollEnabled = false
    view.layer.masksToBounds = true
    view.layer.cornerRadius = properties.cornerRadius
    
    view.frame = properties.frame
  }
  
  func animatePresentation(options: WWDCTransitionAnimationOptions, finalFrame: CGRect, completion: @escaping () -> Void) {
    UIView.animate(withDuration: options.duration, delay: 0,
                   usingSpringWithDamping: options.damping, initialSpringVelocity: options.initialVelocity,
                   options: .curveEaseOut,
                   animations: {
                    self.view.layer.cornerRadius = 0
                    self.view.frame = finalFrame
    }) { _ in
      self.scrollView.isScrollEnabled = true
      self.view.layer.masksToBounds = false
      completion()
    }
  }
  
  func animateDismissal(options: WWDCTransitionAnimationOptions, completion: @escaping () -> Void) {
    guard let properties = transitionProperties else {
      return
    }
    scrollView.isScrollEnabled = false
    view.layer.masksToBounds = true
    
    UIView.animate(withDuration: options.duration, delay: 0,
                   usingSpringWithDamping: options.damping, initialSpringVelocity: options.initialVelocity,
                   options: .curveEaseInOut,
                   animations: {
                    self.scrollView.contentOffset = .zero
                    self.view.layer.cornerRadius = properties.cornerRadius
                    self.view.frame = properties.frame
    }) { _ in
      self.transitionProperties = nil
      completion()
    }
  }
}
