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
  
}

enum ShareType {
  case Facebook
  case Twitter
  case LinkedIn
  case Viadeo
  case Mail
  
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
    }
    return image
  }
  
  static func all() -> [ShareType] {
    return [.Facebook, .Twitter, .LinkedIn, .Viadeo, .Mail]
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
      container.contentInset = UIEdgeInsets(top: 4,
                                            left: 4,
                                            bottom: 4,
                                            right: 4)
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
  lazy private var containerButtons: [CALayer] = {
    var buttons = [CALayer]()
    var l: CALayer
    let cornerRadius = (self.container.bounds.height - self.container.contentInset.top - self.container.contentInset.bottom) * 0.5
    for type in self.shareItems {
      l = self.layerButton(withRadius: cornerRadius, type: type)
      self.container.layer.addSublayer(l)
      buttons.append(l)
    }
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
  
  private func layerButton(withRadius radius: CGFloat, type: ShareType) -> CALayer {
    let l = CALayer()
    let innerLayer = CALayer()
    innerLayer.bounds = CGRect(x: 0,
                               y: 0,
                               width: radius,
                               height: radius)
    innerLayer.position = CGPoint(x: radius, y: radius)
    innerLayer.contents = type.icon().cgImage
    innerLayer.contentsGravity = kCAGravityResizeAspectFill
    l.addSublayer(innerLayer)
    l.backgroundColor = UIColor.white.cgColor
    l.cornerRadius = radius
    l.bounds = CGRect(x: 0,
                      y: 0,
                      width: radius * 2,
                      height: radius * 2)
    return l
  }
  
  private func displayButtons() {
    reinitButtonPosition()
    
  }
  
  private func reinitButtonPosition() {
    for i in 0..<containerButtons.count {
      containerButtons[i].position = CGPoint(x: containerButtons[i].bounds.width * 0.5 + CGFloat(i) * (containerButtons[i].bounds.width + 4),
                                             y: containerButtons[i].bounds.height * 0.5)
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
