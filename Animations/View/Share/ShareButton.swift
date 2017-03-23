//
//  ShareButton.swift
//  Animations
//
//  Created by AbsolutRenal on 17/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit


protocol ShareButtonDelegate: class {
  func didTapShareButton(withType type: ShareType)
}

enum ShareType {
  case Facebook
  case Twitter
  case LinkedIn
  case Viadeo
  case Mail
  case Vimeo
  case Behance
  
  func icon() -> UIImage {
    let image: UIImage
    switch self {
    case .Facebook:
      image = #imageLiteral(resourceName: "fb_icon")
    case .Twitter:
      image = #imageLiteral(resourceName: "twitter_icon")
    case .LinkedIn:
      image = #imageLiteral(resourceName: "linkedIn_icon")
    case .Viadeo:
      image = #imageLiteral(resourceName: "viadeo_icon")
    case .Mail:
      image = #imageLiteral(resourceName: "mail_icon")
    case .Vimeo:
      image = #imageLiteral(resourceName: "vimeo_icon")
    case .Behance:
      image = #imageLiteral(resourceName: "behance_icon")
    }
    return image
  }
  
  static func all() -> [ShareType] {
    return [.Facebook, .Twitter, .LinkedIn, .Viadeo, .Mail, .Vimeo, .Behance]
  }
}

class ShareButton: UIView, Animatable, ShareTypeButtonDelegate, UIScrollViewDelegate {
  private enum AnimState {
    case Closed
    case Openned
    case Closing
  }
  
  // *********************************************************************
  // MARK: - Constants
  private let inset: CGFloat = 4
  private let displayDelay = 0.2
  private let disappearDelay = 0.2
  private let buttonRotationX: CGFloat = CGFloat(M_PI_2)
  private let shareString = "Share"
  private let thanksString = "Thank you"
  private let openningEase = CAMediaTimingFunction(controlPoints: 0.8, 0, 0.7, 1)
  private let easeInOut = CAMediaTimingFunction(controlPoints: 0.8, 0, 0.8, 1)
  
  // *********************************************************************
  // MARK: - IBOutlet
  @IBOutlet weak var whiteButton: UIButton! {
    didSet {
      whiteButton.titleLabel?.font = UIFont.systemFont(ofSize: 20.0, weight: UIFontWeightLight)
      whiteButton.setTitle(shareString, for: .normal)
      whiteButton.setTitleColor(UIColor(red: 193.0/255.0, green: 193.0/255.0, blue: 193.0/255.0, alpha: 1.0), for: .normal)
      whiteButton.layer.cornerRadius = whiteButton.layer.bounds.height * 0.5
    }
  }
  @IBOutlet weak var container: UIScrollView! {
    didSet {
      container.delegate = self
      container.layer.cornerRadius = container.layer.bounds.height * 0.5
      container.layer.masksToBounds = true
      container.contentInset = UIEdgeInsets(top: inset,
                                            left: inset,
                                            bottom: inset,
                                            right: inset)
    }
  }
  @IBOutlet weak var thanksLabel: UILabel! {
    didSet {
      thanksLabel.font = UIFont.systemFont(ofSize: 20, weight: UIFontWeightLight)
      thanksLabel.text = thanksString
      thanksLabel.textColor = UIColor.white
      thanksLabel.layer.shadowOffset = CGSize(width: 0.4, height: 1.0)
      thanksLabel.layer.shadowOpacity = 0.4
      thanksLabel.layer.shadowColor = UIColor.black.cgColor
      thanksLabel.layer.shadowRadius = 1.0
      let mask = CALayer()
      mask.backgroundColor = UIColor.black.cgColor
      mask.bounds = thanksLabel.layer.bounds
      mask.position = thanksLabel.layer.position
      mask.cornerRadius = container.layer.cornerRadius
      thanksLabel.layer.mask = mask
    }
  }
  
  // *********************************************************************
  // MARK: - Properties
  weak var delegate: ShareButtonDelegate?
  
  lazy private var shareItems: [ShareType] = {
    if let itemsToDisplay = self.items, itemsToDisplay.count > 0 {
      return itemsToDisplay
    } else {
      return ShareType.all()
    }
  }()
  var items: [ShareType]?
  lazy private var containerButtons: [ShareTypeButton] = {
    var buttons = [ShareTypeButton]()
    var button: ShareTypeButton
    self.buttonSize = self.container.bounds.height - self.container.contentInset.top - self.container.contentInset.bottom
    let startFrame = CGRect(x: self.container.bounds.size.width,
                            y: 0,
                            width: self.buttonSize,
                            height: self.buttonSize)
    var i = 0
    for type in self.shareItems {
      button = ShareTypeButton(withType: type,
                               delegate: self,
                               startFrame: startFrame,
                               endFrame: CGRect(x: CGFloat(i) * (self.buttonSize + self.inset),
                                                y: 0,
                                                width: self.buttonSize,
                                                height: self.buttonSize))
      self.container.addSubview(button)
      buttons.append(button)
      i += 1
    }
    self.container.contentSize = CGSize(width: (self.buttonSize + self.inset) * CGFloat(i) - self.inset,
                                        height: self.buttonSize)
    return buttons
  }()
  
  private var buttonSize: CGFloat = 0
  private var firstDisplayedIndex = 0
  private var animationRunning = false
  private var didTapShare = false
  private var state: AnimState = .Closed
  private var animCompletion: [AnimState: (() -> Void)] = [AnimState: (() -> Void)]()
  private var completion: (() -> Void)? {
    get {
      return animCompletion[state]
    }
    set {
      animCompletion[state] = newValue
    }
  }
  
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
  // MARK: - Private
  private func configure() {
    layer.cornerRadius = layer.bounds.height * 0.5
  }
  
  private func openBox() {
    if !animationRunning && state == .Closed {
      reinit()
      animationRunning = true
      whiteButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
      whiteButton.layer.position = CGPoint(x: whiteButton.layer.position.x,
                                           y: 0)
      let open = buildKeyFrameAnimation(keyPath: "transform.rotation.x",
                                        values: [0.0, M_PI_2],
                                        keyTimes: [0.0, 1.0],
                                        duration: 0.5,
                                        delegate: self,
                                        timingFunctions: [openningEase])
      whiteButton.layer.add(open, forKey: "open")
      whiteButton.layer.transform = CATransform3DRotate(CATransform3DIdentity, buttonRotationX, 1.0, 0.0, 0.0)
      completion = {
        self.state = .Openned
        self.displayButtons()
      }
    }
  }
  
  private func displayButtons() {
    for i in 0..<containerButtons.count {
      let delay = displayDelay * Double(i)
      containerButtons[i].display(delay: NSNumber(value: delay))
    }
  }
  
  private func reinit() {
    didTapShare = false
    firstDisplayedIndex = 0
    thanksLabel.frame = container.frame.offsetBy(dx: 0, dy: -container.frame.size.height)
    container.contentOffset = CGPoint(x: -inset, y: -inset)
    reinitButtonPosition()
  }
  
  private func reinitButtonPosition() {
    containerButtons.forEach {
      $0.reinit()
    }
  }
  
  private func showThanks() {
    let show = buildKeyFrameAnimation(keyPath: "position.y",
                                      values: [thanksLabel.layer.position.y,
                                               container.layer.position.y],
                                      keyTimes: [0.0, 1.0],
                                      duration: 0.2,
                                      delegate: self,
                                      timingFunctions: [easeInOut])
    thanksLabel.layer.add(show, forKey: "show")
    thanksLabel.layer.frame = container.layer.frame
    
    completion = {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.8,
                                    execute: { [weak self] in
                                      self?.close()
      })
    }
  }
  
  private func close() {
    let close = buildKeyFrameAnimation(keyPath: "transform.rotation.x",
                                       values: [buttonRotationX, 0.0],
                                       keyTimes: [0.0, 1.0],
                                       duration: 0.2,
                                       delegate: self,
                                       timingFunctions: [openningEase])
    whiteButton.layer.add(close, forKey: "close")
    whiteButton.layer.transform = CATransform3DIdentity
    completion = {
      self.state = .Closed
    }
  }
  
  // *********************************************************************
  // MARK: - IBAction
  @IBAction func whiteButtonDidTap(_ sender: UIButton) {
    openBox()
  }
  
  // *********************************************************************
  // MARK: - UIScrollViewDelegate
  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    var i = 0
    let offset: CGPoint = containerButtons.reduce(CGPoint.zero) { (last, current) in
      defer {
        i += 1
      }
      if abs(targetContentOffset.pointee.x - current.frame.origin.x - inset) < abs(targetContentOffset.pointee.x - last.x - inset) {
        firstDisplayedIndex = i
        return current.frame.origin
      } else {
        return last
      }
    }
    targetContentOffset.pointee = CGPoint(x: offset.x - inset, y:offset.y)
  }
  
  // *********************************************************************
  // MARK: - CAAnimationDelegate
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    animationRunning = false
    completion?()
  }
  
  // *********************************************************************
  // MARK: - ShareTypeButtonDelegate
  func shouldSelectButton() -> Bool {
    return !didTapShare
  }
  
  func didTapShareButton(withType type: ShareType) {
    didTapShare = true
    state = .Closing
    
    let disappearCompletion = {
      self.delegate?.didTapShareButton(withType: type)
      self.showThanks()
    }
    
    var delay = 0.0
    for i in firstDisplayedIndex..<firstDisplayedIndex+4 {
      let c: (() -> Void)? = i == (firstDisplayedIndex + 3) ? disappearCompletion : nil
      containerButtons[i].disappear(delay: NSNumber(value: delay), completion: c)
      delay += disappearDelay
    }
  }
}
