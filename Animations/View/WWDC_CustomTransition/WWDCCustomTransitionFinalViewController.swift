//
//  WWDCCustomTransitionFinalViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 04/12/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class WWDCCustomTransitionFinalViewController: UIViewController {
  // MARK: - Constants
  private enum Constants {
    static let minScrollOffsetBeforeDismiss: CGFloat = -200
  }
  
  // MARK: - IBOutlets
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private var heightConstraint: NSLayoutConstraint!
  
  // MARK: - Properties
  private lazy var  tapGesture: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
  }()
  private var transitionProperties: WWDCTransitionProperties?
  private var image: UIImage?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    imageView.image = UIImage(named: "LandscapePhoto")
    imageView.layer.masksToBounds = true
    scrollView.delegate = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    heightConstraint.constant = image?.size.height ?? 0
    imageView.image = image
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
  func configure(with image: UIImage?) {
    self.image = image
  }
  
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
                    self.scrollView.bounces = false
                    self.scrollView.contentOffset = .zero
                    self.view.layer.cornerRadius = properties.cornerRadius
                    self.view.frame = properties.frame
    }) { _ in
      self.transitionProperties = nil
      completion()
    }
  }
}

extension WWDCCustomTransitionFinalViewController: UIScrollViewDelegate {
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if scrollView.contentOffset.y <= Constants.minScrollOffsetBeforeDismiss {
      dismiss(animated: true, completion: nil)
    }
  }
}
