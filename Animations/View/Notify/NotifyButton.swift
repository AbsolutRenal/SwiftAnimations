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
      placeholder.sizeToFit()
    }
  }
  @IBOutlet weak var inputLabel: UITextField! {
    didSet {
      inputLabel.layer.opacity = 0.0
      inputLabel.isHidden = true
      inputLabel.delegate = self
    }
  }
  @IBOutlet weak var sendButton: UIButton! {
    didSet {
      sendButton.layer.cornerRadius = sendButton.bounds.height * 0.5
      sendButton.layer.opacity = 0.0
      sendButton.setTitle(sendLabel, for: .normal)
      activateSendButton(activate: false)
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
  private var animCompletion: [NotifyButtonState: (() -> Void)] = [NotifyButtonState: (() -> Void)]()
  private var completion: (() -> Void)? {
    set {
      animCompletion[state] = newValue
    }
    get {
      return animCompletion[state]
    }
  }
  
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
  // MARK: - IBAction
  @IBAction func sendButtonDidTap(_ sender: UIButton) {
    
  }
  
  // *********************************************************************
  // MARK: - Private Methods
  private func configure() {
    layer.cornerRadius = bounds.height * 0.5
  }
  
  private func buildKeyFrameAnimation(keyPath: String,
                                      values: [Any],
                                      keyTimes: [NSNumber]?,
                                      duration: CFTimeInterval = 0,
                                      delegate: CAAnimationDelegate? = nil,
                                      calculationMode: String? = kCAAnimationLinear) -> CAKeyframeAnimation {
    let anim = CAKeyframeAnimation(keyPath: keyPath)
    anim.values = values
    anim.keyTimes = keyTimes
    anim.delegate = delegate
    anim.fillMode = kCAFillModeForwards
    anim.isRemovedOnCompletion = false
    anim.duration = duration
    return anim
  }
  
  private func buildAnimationGroup(animations: [CAAnimation],
                                   duration: CFTimeInterval,
                                   delegate: CAAnimationDelegate? = nil) -> CAAnimationGroup {
    let anim = CAAnimationGroup()
    anim.animations = animations
    anim.duration = duration
    anim.delegate = delegate
    anim.fillMode = kCAFillModeForwards
    anim.isRemovedOnCompletion = false
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
    
  }
  
  private func animateToEmail() {
    let labelFadeOut = buildKeyFrameAnimation(keyPath: "opacity",
                                         values: [1, 0],
                                         keyTimes: [0, 0.2],
                                         duration: 1.0)
    
    
    var w: CGFloat = desiredMaxWith
    if let superWidth = superview?.bounds.size.width {
      w = min(desiredMaxWith, superWidth - 16)
    }
    let destBounds = CGRect(x: layer.bounds.origin.x,
                            y: layer.bounds.origin.y,
                            width: w,
                            height: layer.bounds.size.height)
    let grow = buildKeyFrameAnimation(keyPath: "bounds",
                                      values: [layer.bounds,
                                               destBounds],
                                      keyTimes: [0.2, 0.5],
                                      duration: 1.0)
    layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    
    let emailFadeIn = buildKeyFrameAnimation(keyPath: "opacity",
                                             values: [0, 0.5],
                                             keyTimes: [0.5, 0.7],
                                             duration: 1.0)
    
    let inputFadeIn = buildKeyFrameAnimation(keyPath: "opacity",
                                             values: [0, 1],
                                             keyTimes: [0.5, 0.7],
                                             duration: 1.0,
                                             delegate: self)
    
    let offsetWidth = w - layer.bounds.size.width
    sendButton.layer.position.x += offsetWidth
    let sendButtonFadeIn = buildKeyFrameAnimation(keyPath: "opacity",
                                                  values: [0, 1],
                                                  keyTimes: [0.5, 0.7],
                                                  duration: 1.0)
    inputLabel.layer.frame.size.width += offsetWidth
    
    label.layer.add(labelFadeOut, forKey: "labelFadeOut")
    layer.add(grow, forKey: "grow")
    placeholder.layer.add(emailFadeIn, forKey: "emailFadeIn")
    inputLabel.layer.add(inputFadeIn, forKey: "inputFadeIn")
    sendButton.layer.add(sendButtonFadeIn, forKey: "sendButtonFadeIn")
    
    completion = activateEmailState
  }
  
  private func animateToThanks() {
    
  }
  
  private func activateEmailState() {
    inputLabel.isHidden = false
    inputLabel.becomeFirstResponder()
  }
  
  
  // *********************************************************************
  // MARK: - Touch
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    if state == .AskForNotification {
      animate(toState: .AskEmail)
    }
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
  
  private func isValidEmail(_ email: String) -> Bool {
    let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluate(with: email)
  }
  
  private func activateSendButton(activate: Bool) {
    sendButton.isEnabled = activate
    sendButton.titleLabel?.layer.opacity = activate ? 1.0 : 0.5
  }
  
  // *********************************************************************
  // MARK: - UITextFieldDelegate Methods
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let email = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
    placeholder.isHidden = email.characters.count > 0
    activateSendButton(activate: isValidEmail(email))
    return true
  }
  
  
  // *********************************************************************
  // MARK: - CAAnimationDelegate Methods
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    completion?()
    animationRunning = false
    updateState()
  }
}
