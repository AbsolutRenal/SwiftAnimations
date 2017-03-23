//
//  ShareTypeButton.swift
//  Animations
//
//  Created by AbsolutRenal on 22/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

protocol ShareTypeButtonDelegate {
  func shouldSelectButton() -> Bool
  func didTapShareButton(withType type: ShareType)
}

class ShareTypeButton: UIButton, Animatable {
  // *********************************************************************
  // MARK: - Constants
  private let appearEasing = CAMediaTimingFunction(controlPoints: 0.52, 0.07, 0.16, 1)
  private let disappearEasing = CAMediaTimingFunction(controlPoints: 0.7, 0, 0.5, 1)
  private let color: UIColor = UIColor(red: 54.0/255.0, green: 139.0/255.0, blue: 139.0/255.0, alpha: 1.0)
  private let backgroundDeselectedColor: UIColor = UIColor.white
  private let backgroundSelectedColor: UIColor = UIColor(red: 233.0/255.0, green: 79.0/255.0, blue: 137.0/255.0, alpha: 1.0)
  private let offsetY: CGFloat = 40
  
  // *********************************************************************
  // MARK: - Properties
  var delegate: ShareTypeButtonDelegate
  private var type: ShareType
  private var startFrame: CGRect
  private var endFrame: CGRect
  private let size: CGFloat
  private var completion: (() -> Void)?
  
  // *********************************************************************
  // MARK: - Lifecycle
  required init(withType type: ShareType, delegate: ShareTypeButtonDelegate, startFrame: CGRect, endFrame: CGRect) {
    self.type = type
    self.delegate = delegate
    self.startFrame = startFrame
    self.endFrame = endFrame
    size = startFrame.size.width
    super.init(frame: startFrame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Should use init(withType:frame:)")
    return nil
  }

  // *********************************************************************
  // MARK: - Private
  private func configure() {
    layer.cornerRadius = frame.size.height * 0.5
    layer.backgroundColor = backgroundDeselectedColor.cgColor
    
    let image = type.icon().withRenderingMode(.alwaysTemplate)
    let iconView = UIImageView(frame: bounds.insetBy(dx: 8, dy: 8))
    iconView.image = image
    iconView.contentMode = .scaleAspectFill
    addSubview(iconView)
    
    tintColor = color
    
    addTarget(self, action: #selector(didTap), for: .touchUpInside)
  }
  
  // *********************************************************************
  // MARK: - Public
  func reinit() {
    frame = startFrame
    layer.backgroundColor = backgroundDeselectedColor.cgColor
  }
  
  func display(delay: NSNumber, completion: (() -> Void)? = nil) {
    self.completion = completion
    let move = buildKeyFrameAnimation(keyPath: "position.x",
                                         values: [startFrame.origin.x + size * 0.5, endFrame.origin.x + size * 0.5],
                                         keyTimes: [delay, 1.0],
                                         duration: 0.0,
                                         delegate: nil,
                                         timingFunctions: [appearEasing])
    let rotate = buildKeyFrameAnimation(keyPath: "transform.rotation.z",
                                        values: [M_PI / 2.0, 0.0],
                                        keyTimes: [delay, 1.0],
                                        duration: 0.0,
                                        delegate: nil,
                                        timingFunctions: [appearEasing])
    let display = buildAnimationGroup(animations: [move, rotate],
                                      duration: 0.6,
                                      delegate: self)
    layer.add(display, forKey: "display")
    layer.frame = endFrame
  }
  
  func disappear(delay: NSNumber, completion: (() -> Void)? = nil) {
    self.completion = completion
    let move = buildKeyFrameAnimation(keyPath: "position.y",
                                      values: [layer.position.y, layer.position.y + offsetY],
                                      keyTimes: [delay, 1.0],
                                      duration: 0.6,
                                      delegate: self,
                                      timingFunctions: [disappearEasing])
    layer.add(move, forKey: "disappear")
    layer.frame = layer.frame.offsetBy(dx: 0, dy: offsetY)
  }
  
  // *********************************************************************
  // MARK: - IBAction
  @IBAction func didTap(_ sender: UIButton) {
    if delegate.shouldSelectButton() {
      let colorSelection = buildKeyFrameAnimation(keyPath: "backgroundColor",
                                                  values: [backgroundDeselectedColor.cgColor,
                                                           backgroundSelectedColor.cgColor,
                                                           backgroundDeselectedColor.cgColor],
                                                  keyTimes: [0.0, 0.5, 1.0],
                                                  duration: 0.3,
                                                  delegate: self,
                                                  timingFunctions: nil)
      layer.add(colorSelection, forKey: "colorSelection")
      self.delegate.didTapShareButton(withType: self.type)
    }
  }
  
  // *********************************************************************
  // MARK: - CAAnimationDelegate
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    completion?()
    completion = nil
  }
}
