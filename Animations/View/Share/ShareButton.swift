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

class ShareButton: UIView, Animatable, UIScrollViewDelegate {
  private enum AnimState {
    case Closed
    case DisplayButtons
    case Openned
  }
  
  // *********************************************************************
  // MARK: - Constants
  private let inset: CGFloat = 4
  private let displayDelay = 0.2
  private let shareLabel = "Share"
  private let openningEase = CAMediaTimingFunction(controlPoints: 0.8, 0, 0.7, 1)
  
  // *********************************************************************
  // MARK: - IBOutlet
  @IBOutlet weak var whiteButton: UIButton! {
    didSet {
      whiteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightThin)
      whiteButton.setTitle(shareLabel, for: .normal)
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
    let size = self.container.bounds.height - self.container.contentInset.top - self.container.contentInset.bottom
    let startFrame = CGRect(x: self.container.bounds.size.width,
                            y: 0,
                            width: size,
                            height: size)
    var i = 0
    for type in self.shareItems {
      button = ShareTypeButton(withType: type,
                               startFrame: startFrame,
                               endFrame: CGRect(x: CGFloat(i) * (size + self.inset),
                                                y: 0,
                                                width: size,
                                                height: size))
      self.container.addSubview(button)
      buttons.append(button)
      i += 1
    }
    self.container.contentSize = CGSize(width: (size + self.inset) * CGFloat(i) - self.inset,
                                        height: size)
    return buttons
  }()
  
  private var animationRunning = false
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
      whiteButton.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI_2), 1.0, 0.0, 0.0)
      completion = {
        self.state = .DisplayButtons
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
  
  private func reinitButtonPosition() {
    containerButtons.forEach {
      $0.reinit()
    }
  }
  
  // *********************************************************************
  // MARK: - IBAction
  @IBAction func whiteButtonDidTap(_ sender: UIButton) {
    openBox()
  }
  
  // *********************************************************************
  // MARK: - UIScrollViewDelegate
  
  // *********************************************************************
  // MARK: - CAAnimationDelegate
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    animationRunning = false
    completion?()
  }
}
