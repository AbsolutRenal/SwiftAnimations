//
// Created by AbsolutRenal on 16/10/2017.
// Copyright (c) 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

enum CircleMenuAction {
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

  static func all() -> [CircleMenuAction] {
    return [.Facebook, .Twitter, .LinkedIn, .Viadeo, .Mail, .Vimeo, .Behance]
  }
}

protocol CircleMenuActionDelegate: class {
  func didTapButton(withType type: CircleMenuAction)
  func shouldSelectButton() -> Bool
  func didEndTapAnimation()
}

class CircleMenuActionButton: UIButton, Animatable {
  // *********************************************************************
  // MARK: - Constants
  private let kLayerBackgroundOpacity: CGFloat = 1.0
  private let kLayerBackgroundSelectedOpacity: CGFloat = 0.5
  private let kTintColor: UIColor = .darkGray
  private let kStrokeTintColor: UIColor = .black
  private let kTimingFunctionEaseInOut = CAMediaTimingFunction(controlPoints: 0.32,
                                                                   0.0,
                                                                   0.39,
                                                                   1.18)

  // *********************************************************************
  // MARK: - Properties
  private var type: CircleMenuAction
  weak var delegate: CircleMenuActionDelegate?
  private var touchedDown = false
  private var completion: (() -> Void)?

  // *********************************************************************
  // MARK: - LifeCycle
  required init?(coder aDecoder: NSCoder) {
    fatalError("Should use init(withType:delegate:frame:)")
    return nil
  }

  required init(withType type: CircleMenuAction,
                delegate: CircleMenuActionDelegate,
                frame: CGRect) {
    self.type = type
    self.delegate = delegate
    super.init(frame: frame)
    setup()
  }

  // *********************************************************************
  // MARK: - IBActions
  @IBAction func didTouchDown(sender: CircleMenuActionButton) {
    guard shouldSelect() else {
      return
    }
    touchedDown = true
    setTouchedState()
  }
  
  @IBAction func didTouchDragEnter(sender: CircleMenuActionButton) {
    guard shouldSelect() && touchedDown else {
      return
    }
    setTouchedState()
  }
  
  @IBAction func didTouchDragExit(sender: CircleMenuActionButton) {
    guard shouldSelect() else {
      return
    }
    animateToReleasedState()
  }
  
  @IBAction func didTouchUpInside(sender: CircleMenuActionButton) {
    guard shouldSelect() else {
      return
    }
    touchedDown = false
    completion = delegate?.didEndTapAnimation
    delegate?.didTapButton(withType: type)
    animateToReleasedState()
  }
  
  @IBAction func didTouchUpOutside(sender: CircleMenuActionButton) {
    touchedDown = false
  }

  // *********************************************************************
  // MARK: - Private methods
  private func setup() {
    layer.cornerRadius = frame.size.height * 0.5
    layer.backgroundColor = UIColor.white.withAlphaComponent(kLayerBackgroundOpacity).cgColor
    layer.borderWidth = 0.0
    layer.borderColor = kStrokeTintColor.cgColor

    let image = type.icon().withRenderingMode(.alwaysTemplate)
    let iconView = UIImageView(frame: bounds.insetBy(dx: 12, dy: 12))
    iconView.image = image
    iconView.contentMode = .scaleAspectFill
    addSubview(iconView)

    tintColor = kTintColor

    addTarget(self, action: #selector(didTouchDown), for: .touchDown)
    addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
    addTarget(self, action: #selector(didTouchUpOutside), for: .touchUpOutside)
    addTarget(self, action: #selector(didTouchDragEnter), for: .touchDragEnter)
    addTarget(self, action: #selector(didTouchDragExit), for: .touchDragExit)
  }
  
  private func shouldSelect() -> Bool {
    return delegate?.shouldSelectButton() ?? false
  }
  
  private func setTouchedState() {
    layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1)
    layer.opacity = Float(kLayerBackgroundSelectedOpacity)
    layer.borderWidth = 3.0
  }
  
  private func animateToReleasedState() {
    let scaleAnim = buildKeyFrameAnimation(keyPath: "transform.scale",
                                           values: [1.2, 1.0],
                                           keyTimes: [0.0, 1.0],
                                           duration: 0.0,
                                           fillMode: .forwards,
                                           beginTime: nil,
                                           delegate: nil,
                                           timingFunctions: nil)
    let alphaAnim = buildKeyFrameAnimation(keyPath: "opacity",
                                           values: [kLayerBackgroundSelectedOpacity, kLayerBackgroundOpacity],
                                           keyTimes: [0.0, 1.0],
                                           duration: 0.0,
                                           fillMode: .forwards,
                                           beginTime: nil,
                                           delegate: nil,
                                           timingFunctions: nil)
    let strokeAnim = buildKeyFrameAnimation(keyPath: "borderWidth",
                                            values: [3.0, 0.0],
                                            keyTimes: [0.0, 1.0],
                                            duration: 0.0,
                                            fillMode: .forwards,
                                            beginTime: nil,
                                            delegate: nil,
                                            timingFunctions: nil)
    let tapAnim = buildAnimationGroup(animations: [scaleAnim, alphaAnim, strokeAnim],
                                      duration: 0.3,
                                      fillMode: .forwards,
                                      beginTime: nil,
                                      delegate: self)
    tapAnim.timingFunction = kTimingFunctionEaseInOut
    layer.add(tapAnim, forKey: "tapAnim")
    
    layer.transform = CATransform3DIdentity
    layer.borderWidth = 0
    layer.opacity = Float(kLayerBackgroundOpacity)
  }

  // *********************************************************************
  // MARK: - CAAnimationDelegate
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    guard flag else {
      return
    }
    completion?()
    completion = nil
  }
}
