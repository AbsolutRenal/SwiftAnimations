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
    case HideThanks
    case AskForNotification
    case AskEmail
    case Thanks
  }
  
  // *********************************************************************
  // MARK: - IBOutlet
  @IBOutlet weak var label: UIButton! {
    didSet {
      label.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: UIFontWeightSemibold)
      label.setTitleColor(UIColor(red: 255.0/255.0,
                                  green: 145.0/255.0,
                                  blue: 133.0/255.0,
                                  alpha: 255.0/255.0),
                          for: .normal)
      label.setTitle(notifyLabel, for: .normal)
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
  private let halfScaleTransform = CATransform3DScale(CATransform3DIdentity, 0.5, 0.5, 1.0)
  
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
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
  }
  
  // *********************************************************************
  // MARK: - IBAction
  @IBAction func expandButton(_ sender: UIButton) {
    if state == .AskForNotification {
      animate(toState: .AskEmail)
    }
  }
  
  @IBAction func sendButtonDidTap(_ sender: UIButton) {
    guard let email = inputLabel.text else {
      return
    }
    delegate?.sendButtonDidTap(email: email)
    inputLabel.resignFirstResponder()
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
      case .HideThanks:
        animateHideThanks()
      }
    }
  }
  
  private func easeInOut() -> CAMediaTimingFunction {
    return CAMediaTimingFunction(controlPoints: 0.65, 0, 0.35, 1)
  }
  
  private func animateHideThanks() {
    let labelDisappear = buildAnimationGroup(animations: [buildKeyFrameAnimation(keyPath: "opacity",
                                                                                 values: [1.0, 0.0],
                                                                                 keyTimes: [0.0, 1.0],
                                                                                 delegate: nil,
                                                                                 timingFunctions: [easeInOut()]),
                                                          buildKeyFrameAnimation(keyPath: "transform.scale",
                                                                                 values: [1.0,
                                                                                          0.5],
                                                                                 keyTimes: [0.0, 1.0],
                                                                                 duration: 0.0,
                                                                                 delegate: nil,
                                                                                 timingFunctions: [easeInOut()])],
                                             duration: 0.2,
                                             delegate: self)
    completion = { [weak self] in
      self?.label.setTitle(self?.notifyLabel, for: .normal)
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.1,
                                    execute: { 
                                      self?.animate(toState: .AskForNotification)
      })
    }
    label.layer.add(labelDisappear, forKey: "labelDisappear")
    label.layer.opacity = 0.0
    label.layer.transform = halfScaleTransform
  }
  
  private func animateToNotify() {
    let labelAppear = buildAnimationGroup(animations: [buildKeyFrameAnimation(keyPath: "opacity",
                                                                              values: [0.0, 1.0],
                                                                              keyTimes: [0.0, 1.0],
                                                                              duration: 0.0,
                                                                              delegate: nil,
                                                                              timingFunctions: [easeInOut()]),
                                                       buildKeyFrameAnimation(keyPath: "transform.scale",
                                                                              values: [0.5, 1.0],
                                                                              keyTimes: [0.0, 1.0],
                                                                              duration: 0.0,
                                                                              delegate: nil,
                                                                              timingFunctions: [easeInOut()])],
                                          duration: 0.2,
                                          delegate: self)
    completion = { [weak self] in
      self?.label.isEnabled = true
    }
    label.layer.add(labelAppear, forKey: "labelAppear")
    label.layer.opacity = 1.0
    label.layer.transform = CATransform3DIdentity
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
    placeholder.layer.transform = halfScaleTransform
    placeholder.isHidden = false
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
    label.layer.opacity = 0.0
    label.layer.transform = halfScaleTransform
    
    background.layer.add(grow, forKey: "grow")
    background.layer.bounds = layer.bounds
    
    placeholder.layer.add(placeholderDisplay, forKey: "placeholderDisplay")
    placeholder.layer.opacity = 0.5
    placeholder.layer.transform = CATransform3DIdentity
    
    sendButton.layer.add(sendButtonDisplay, forKey: "sendButtonDisplay")
    sendButton.layer.opacity = 1.0
    sendButton.layer.transform = CATransform3DIdentity
    
    completion = { [weak self] in
      self?.inputLabel.layer.transform = CATransform3DIdentity
      self?.inputLabel.layer.opacity = 1.0
      self?.inputLabel.text = ""
      self?.inputLabel.isHidden = false
      self?.inputLabel.becomeFirstResponder()
      self?.label.isEnabled = false
    }
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
    
    let destBackgroundBounds = CGRect(x: layer.bounds.width - backgroundStartWidth * 0.5,
                                      y: background.layer.bounds.origin.y,
                                      width: backgroundStartWidth,
                                      height: background.layer.bounds.height)
    let shrink = buildKeyFrameAnimation(keyPath: "bounds",
                                        values: [background.layer.bounds,
                                                 destBackgroundBounds],
                                        keyTimes: [0.2, 0.5],
                                        duration: 1.0,
                                        delegate: nil,
                                        timingFunctions: [easeInOut()])

    label.setTitle(thanksLabel, for: .normal)
    let labelFadeIn = buildAnimationGroup(animations: [buildKeyFrameAnimation(keyPath: "opacity",
                                                                              values: [0, 1],
                                                                              keyTimes: [0.2, 0.5],
                                                                              delegate: nil,
                                                                              timingFunctions: [easeInOut()]),
                                                       buildKeyFrameAnimation(keyPath: "transform.scale",
                                                                              values: [0.5, 1.0],
                                                                              keyTimes: [0.2, 0.5],
                                                                              delegate: nil,
                                                                              timingFunctions: [easeInOut()])],
                                          duration: 1.0,
                                          delegate: self)
    
    inputLabel.layer.add(inputLabelDisappear, forKey: "inputLabelDisappear")
    inputLabel.layer.opacity = 0.0
    inputLabel.layer.transform = halfScaleTransform
    
    sendButton.layer.add(sendButtonDisappear, forKey: "sendButtonDisappear")
    sendButton.layer.opacity = 0.0
    sendButton.layer.transform = halfScaleTransform
    
    background.layer.add(shrink, forKey: "shrink")
    background.layer.bounds = destBackgroundBounds
    
    label.layer.add(labelFadeIn, forKey: "labelFadeIn")
    label.layer.opacity = 1.0
    label.layer.transform = CATransform3DIdentity
    
    completion = { [weak self] in
      self?.inputLabel.isHidden = true
      DispatchQueue.main.asyncAfter(deadline: .now() + 2.0,
                                    execute: { [weak self] in
                                      self?.animate(toState: .HideThanks)
      })
    }
  }
  
  private func updateState() {
    switch state {
    case .AskForNotification:
      state = .AskEmail
    case .AskEmail:
      state = .Thanks
    case .Thanks:
      state = .HideThanks
    case .HideThanks:
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
    animationRunning = false
    completion?()
    updateState()
  }
}
