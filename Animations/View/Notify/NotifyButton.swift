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
      inputLabel.isHidden = true
      inputLabel.delegate = self
    }
  }
  @IBOutlet weak var sendButton: UIButton! {
    didSet {
      sendButton.layer.cornerRadius = sendButton.bounds.height * 0.5
      sendButton.layer.opacity = 0.0
      sendButton.setTitle(sendLabel, for: .normal)
      sendButton.setTitleColor(UIColor.white, for: .normal)
      sendButton.setTitleColor(UIColor(white: 1.0, alpha: 0.5), for: .disabled)
      activateSendButton(activate: false)
    }
  }
  @IBOutlet weak var background: UIView! {
    didSet {
      background.layer.cornerRadius = background.bounds.size.height * 0.5
    }
  }
  
  // *********************************************************************
  // MARK: - Properties
  private let notifyLabel = "Notify me"
  private let thanksLabel = "Thank you!"
  private let placeHolderLabel = "E-mail"
  private let sendLabel = "Send"
  private let backgroundStartWidth: CGFloat = 120.0
  
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
  private lazy var tapGesture: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self,
                                  action: #selector(expandButton))
  }()
  
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
  
  private func configure() {
    addTapGesture()
  }
  
  private func addTapGesture() {
    addGestureRecognizer(tapGesture)
  }
  
  private func removeTapGesture() {
    removeGestureRecognizer(tapGesture)
  }
  
  // *********************************************************************
  // MARK: - IBAction
  func expandButton() {
    if state == .AskForNotification {
      animate(toState: .AskEmail)
    }
  }
  
  @IBAction func sendButtonDidTap(_ sender: UIButton) {
    guard let email = inputLabel.text else {
      return
    }
    delegate?.sendButtonDidTap(email: email)
    activateSendButton(activate: false)
    animate(toState: .Thanks)
  }
  
  // *********************************************************************
  // MARK: - Private Methods
  private func buildKeyFrameAnimation(keyPath: String,
                                      values: [Any],
                                      keyTimes: [NSNumber]?,
                                      duration: CFTimeInterval = 0,
                                      delegate: CAAnimationDelegate? = nil,
                                      timingFunctions: [CAMediaTimingFunction]? = nil) -> CAKeyframeAnimation {
    let anim = CAKeyframeAnimation(keyPath: keyPath)
    anim.values = values
    anim.keyTimes = keyTimes
    anim.delegate = delegate
    anim.fillMode = kCAFillModeForwards
    anim.timingFunctions = timingFunctions
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
  
  private func easeInOut() -> CAMediaTimingFunction {
    return CAMediaTimingFunction(controlPoints: 0.65, 0, 0.35, 1)
  }
  
  private func animateToNotify() {
    
  }
  
  private func animateToEmail() {
    let labelFadeOut = buildAnimationGroup(animations: [buildKeyFrameAnimation(keyPath: "opacity",
                                                                               values: [1, 0],
                                                                               keyTimes: [0, 0.2],
                                                                               delegate: nil,
                                                                               timingFunctions: [easeInOut()]),
                                                        buildKeyFrameAnimation(keyPath: "transform.scale",
                                                                               values: [1.0, 0.5],
                                                                               keyTimes: [0, 0.2],
                                                                               delegate: nil,
                                                                               timingFunctions: [easeInOut()])],
                                           duration: 1.0)
    
    background.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    let grow = buildKeyFrameAnimation(keyPath: "bounds",
                                      values: [background.layer.bounds,
                                               layer.bounds],
                                      keyTimes: [0.2, 0.5],
                                      duration: 1.0,
                                      delegate: nil,
                                      timingFunctions: [easeInOut()])
    
    placeholder.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    placeholder.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.5, 0.5, 1.0)
    let placeholderDisplay = buildAnimationGroup(animations: [buildKeyFrameAnimation(keyPath: "opacity",
                                                                                     values: [0, 0.5],
                                                                                     keyTimes: [0.5, 0.7],
                                                                                     delegate: nil,
                                                                                     timingFunctions: [easeInOut()]),
                                                              buildKeyFrameAnimation(keyPath: "transform.scale",
                                                                                     values: [0.5, 1.0],
                                                                                     keyTimes: [0.5, 0.7],
                                                                                     delegate: nil,
                                                                                     timingFunctions: [easeInOut()])],
                                                 duration: 1.0)
    
    sendButton.layer.transform = CATransform3DScale(CATransform3DIdentity, 0.5, 0.5, 1.0)
    let sendButtonDisplay = buildAnimationGroup(animations: [buildKeyFrameAnimation(keyPath: "opacity",
                                                                                    values: [0, 1],
                                                                                    keyTimes: [0.5, 0.7],
                                                                                    delegate: nil,
                                                                                    timingFunctions: [easeInOut()]),
                                                             buildKeyFrameAnimation(keyPath: "transform.scale",
                                                                                    values: [0.5, 1.0],
                                                                                    keyTimes: [0.5, 0.7],
                                                                                    delegate: nil,
                                                                                    timingFunctions: [easeInOut()])],
                                                duration: 1.0,
                                                delegate: self)
    
    label.layer.add(labelFadeOut, forKey: "labelFadeOut")
    background.layer.add(grow, forKey: "grow")
    placeholder.layer.add(placeholderDisplay, forKey: "placeholderDisplay")
    sendButton.layer.add(sendButtonDisplay, forKey: "sendButtonDisplay")
    
    completion = activateEmailState
  }
  
  private func animateToThanks() {
    inputLabel.sizeToFit()
    inputLabel.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
    let inputLabelDisappear = buildAnimationGroup(animations: [buildKeyFrameAnimation(keyPath: "opacity",
                                                                                      values: [1, 0],
                                                                                      keyTimes: [0.0, 0.15],
                                                                                      delegate: nil,
                                                                                      timingFunctions: [easeInOut()]),
                                                               buildKeyFrameAnimation(keyPath: "transform.scale",
                                                                                      values: [1.0, 0.5],
                                                                                      keyTimes: [0.0, 0.15],
                                                                                      delegate: nil,
                                                                                      timingFunctions: [easeInOut()])],
                                                  duration: 1.0)
    
    let sendButtonDisappear = buildAnimationGroup(animations: [buildKeyFrameAnimation(keyPath: "opacity",
                                                                                      values: [1, 0],
                                                                                      keyTimes: [0.0, 0.15],
                                                                                      delegate: nil,
                                                                                      timingFunctions: [easeInOut()]),
                                                               buildKeyFrameAnimation(keyPath: "transform.scale",
                                                                                      values: [1.0, 0.5],
                                                                                      keyTimes: [0.0, 0.15],
                                                                                      delegate: nil,
                                                                                      timingFunctions: [easeInOut()])],
                                                  duration: 1.0)
    
    let shrink = buildKeyFrameAnimation(keyPath: "bounds",
                                        values: [background.layer.bounds,
                                                 CGRect(x: layer.bounds.width - backgroundStartWidth * 0.5,
                                                        y: background.layer.bounds.origin.y,
                                                        width: backgroundStartWidth,
                                                        height: background.layer.bounds.height)],
                                        keyTimes: [0.2, 0.4],
                                        duration: 1.0,
                                        delegate: nil,
                                        timingFunctions: [easeInOut()])

    label.text = thanksLabel
    let labelFadeIn = buildAnimationGroup(animations: [buildKeyFrameAnimation(keyPath: "opacity",
                                                                              values: [0, 1],
                                                                              keyTimes: [0.2, 0.4],
                                                                              delegate: nil,
                                                                              timingFunctions: [easeInOut()]),
                                                       buildKeyFrameAnimation(keyPath: "transform.scale",
                                                                              values: [0.5, 1.0],
                                                                              keyTimes: [0.2, 0.4],
                                                                              delegate: nil,
                                                                              timingFunctions: [easeInOut()])],
                                          duration: 1.0)
    
    inputLabel.layer.add(inputLabelDisappear, forKey: "inputLabelDisappear")
    sendButton.layer.add(sendButtonDisappear, forKey: "sendButtonDisappear")
    background.layer.add(shrink, forKey: "shrink")
    label.layer.add(labelFadeIn, forKey: "labelFadeIn")
  }
  
  private func activateEmailState() {
    inputLabel.isHidden = false
    inputLabel.becomeFirstResponder()
    removeTapGesture()
  }
  
  
  // *********************************************************************
  // MARK: - Touch
//  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//    super.touchesEnded(touches, with: event)
//    if state == .AskForNotification {
//      animate(toState: .AskEmail)
//    }
//  }
  
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
    sendButton.titleLabel?.setNeedsLayout()
    sendButton.titleLabel?.layoutIfNeeded()
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
