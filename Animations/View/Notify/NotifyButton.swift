//
//  NotifyController.swift
//  Animations
//
//  Created by AbsolutRenal on 01/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

protocol NotifyButtonDelegate: class {
  func sendButtonDidTap(email: String)
}

class NotifyButton: UIView, UITextFieldDelegate, CAAnimationDelegate {
  enum NotifyButtonState {
    case AskForNotification
    case AskEmail
    case Thanks
  }
  
  // *********************************************************************
  // MARK: - IBOutlet
  @IBOutlet weak var label: UILabel! {
    didSet {
      label.text = notifyLabel
    }
  }
  @IBOutlet weak var placeholder: UILabel! {
    didSet {
      placeholder.text = placeHolderLabel
      placeholder.layer.opacity = 0.0
    }
  }
  @IBOutlet weak var inputLabel: UITextField! {
    didSet {
      inputLabel.layer.opacity = 0.0
    }
  }
  @IBOutlet weak var sendButton: UIButton! {
    didSet {
      sendButton.layer.cornerRadius = sendButton.bounds.height * 0.5
      sendButton.layer.opacity = 0.0
      sendButton.setTitle(sendLabel, for: .normal)
    }
  }
  
  // *********************************************************************
  // MARK: - Properties
  private let notifyLabel = "Notify me"
  private let thanksLabel = "Thank you!"
  private let placeHolderLabel = "E-mail"
  private let sendLabel = "Send"
  private let desiredMaxWith: CGFloat = 300.0
  
  private var state: NotifyButtonState = .AskForNotification
  private var animationRunning = false
  
  weak var delegate: NotifyButtonDelegate?
  
  // *********************************************************************
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  
  // *********************************************************************
  // MARK: - Private Methods
  private func configure() {
    layer.cornerRadius = bounds.height * 0.5
  }
  
  private func buildAnimation(keyPath: String,
                              values: [Any],
                              keyTimes: [NSNumber],
                              delegate: CAAnimationDelegate? = nil,
                              timingFunctions: [CAMediaTimingFunction]?,
                              calculationMode: String? = kCAAnimationLinear) -> CAKeyframeAnimation {
    let anim = CAKeyframeAnimation(keyPath: keyPath)
    anim.values = values
    anim.keyTimes = keyTimes
    anim.timingFunctions = timingFunctions
    anim.calculationMode = calculationMode!
    anim.delegate = delegate
    anim.isRemovedOnCompletion = false
    anim.fillMode = kCAFillModeForwards
    return anim
  }
  
  private func animate(toState state: NotifyButtonState) {
    if !animationRunning {
      animationRunning = true
      switch state {
      case .AskForNotification:
        animateToNotify()
      case .AskEmail:
        animateToEmail()
      case .Thanks:
        animateToThanks()
      }
    }
  }
  
  private func animateToNotify() {
    let fadeOut = buildAnimation(keyPath: "opacity",
                                 values: [1, 0],
                                 keyTimes: [0, 0.1])
    
    var w: CGFloat = desiredMaxWith
    if let superWidth = superview?.bounds.size.width {
      w = min(desiredMaxWith, superWidth - 16)
    }
    let grow = buildAnimation(keyPath: "bounds",
                              values: [
                                layer.position,
                                CGRect(x: layer.bounds.origin.x,
                                       y: layer.bounds.origin.y,
                                       width: w,
                                       height: layer.bounds.size.height)
      ],
                              keyTimes: [0.15, 0.30])
  }
  
  private func animateToEmail() {
    
  }
  
  private func animateToThanks() {
    
  }
  
  
  // *********************************************************************
  // MARK: - Touch
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    if state == .AskForNotification {
      animate(toState: .AskEmail)
    }
    
      let group = CAAnimationGroup()
      let fadeOut = buildAnimation(keyPath: "opacity",
                                   values: [1, 0],
                                   keyTimes: [0, 0.1],
                                   timingFunctions: nil)
      
      var w: CGFloat = desiredMaxWith
      if let superWidth = superview?.bounds.size.width {
        w = min(desiredMaxWith, superWidth - 16)
      }
      let grow = buildAnimation(keyPath: "bounds",
                                values: [
                                  CGRect(x: layer.bounds.origin.x,
                                         y: layer.bounds.origin.y,
                                         width: layer.bounds.size.width,
                                         height: layer.bounds.size.height),
                                  CGRect(x: layer.bounds.origin.x,
                                         y: layer.bounds.origin.y,
                                         width: w,
                                         height: layer.bounds.size.height)
        ],
                                keyTimes: [0.15, 0.30],
                                timingFunctions: [
                                  CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        ])
      group.animations = [
        fadeOut,
        grow
      ]
      group.duration = 2
      group.delegate = self
      layer.add(group, forKey: "askForEmail")
      /*animate(layer: label.layer,w
              key: "opacity",
              toValue: 0.0,
              duration: 0.1,
              name: "fadeOut")
      
      var w: CGFloat = desiredMaxWith
      if let superWidth = superview?.bounds.size.width {
        w = min(desiredMaxWith, superWidth - 16)
      }
      animate(layer: layer,
              key: "bounds",
              toValue: CGRect(x: layer.bounds.origin.x,
                              y: layer.bounds.origin.y,
                              width: w,
                              height: layer.bounds.size.height),
              duration: 0.2,
              name: "grow",
              easing: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut),
              delay: 0.1)
      
      animate(layer: placeholder.layer,
              key: "opacity",
              toValue: 0.5,
              duration: 0.1,
              name: "fadeIn",
              easing: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
              delay: 0.3)
      
      animate(layer: inputLabel.layer,
              key: "opacity",
              toValue: 1.0,
              duration: 0.1,
              name: "fadeIn",
              easing: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
              delay: 0.3)
      
      animate(layer: sendButton.layer,
              key: "opacity",
              toValue: 1.0,
              duration: 0.1,
              name: "fadeIn",
              easing: CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut),
              delay: 0.3)*/
//    }
  }
  
  private func updateState() {
    switch state {
    case .AskForNotification:
      state = .AskEmail
    case .AskEmail:
      state = .Thanks
    case .Thanks:
      state = .AskForNotification
    }
  }
  
  // *********************************************************************
  // MARK: - UITextFieldDelegate Methods
  
  
  // *********************************************************************
  // MARK: - CAAnimationDelegate Methods
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    animationRunning = false
    updateState()
  }
}
