//
//  CircleActivityIndicator.swift
//  Animations
//
//  Created by AbsolutRenal on 31/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class CircleActivityIndicator: UIActivityIndicatorView, Animatable {
  // *********************************************************************
  // MARK: - Constants
  private static let ColorAnimation = "colorAnimation"
  private var colors: Stack<CGColor> = {
    var stack = Stack<CGColor>()
    stack.push(UIColor(red: 255/255.0,
                       green: 255/255.0,
                       blue: 255/255.0,
                       alpha: 1.0).cgColor)
    stack.push(UIColor(red: 230/255.0,
                       green: 190/255.0,
                       blue: 18/255.0,
                       alpha: 1.0).cgColor)
    return stack
  }()
  
  private let growEase = CAMediaTimingFunction(controlPoints: 0,
                                               1,
                                               1,
                                               1)
  private let shrinkEase = CAMediaTimingFunction(controlPoints: 1,
                                                 0,
                                                 1,
                                                 1)
  private let easeInOut = CAMediaTimingFunction(controlPoints: 0.5,
                                                0,
                                                0.5,
                                                1)
  private let rotationDelay: CFTimeInterval = 2.0
  private let thickness: CGFloat = 8.0
  
  // *********************************************************************
  // MARK: - IBInspectable
  @IBInspectable var strokeColor: UIColor? {
    didSet {
      circleShape.strokeColor = self.strokeColor!.cgColor
      self.removeColorAnimation()
    }
  }
  
  // *********************************************************************
  // MARK: - IBOutlets
  
  // *********************************************************************
  // MARK: - Properties
  lazy private var circleShape: CAShapeLayer = {
    let shape = CAShapeLayer()
    let path = CGPath(ellipseIn: self.bounds.insetBy(dx: self.thickness * 0.5,
                                                     dy: self.thickness * 0.5),
                      transform: nil)
    shape.path = path
    shape.fillColor = nil
    shape.strokeColor = self.strokeColor?.cgColor ?? UIColor.darkGray.cgColor
    shape.lineWidth = self.thickness
    shape.strokeStart = 0.0
    shape.strokeEnd = 0.0
    
    
    return shape
  }()
  lazy private var circleAnimation: CAAnimation = {
    let growAnim = self.buildKeyFrameAnimation(keyPath: "strokeEnd",
                                               values: [0.0, 1.0],
                                               keyTimes: [0.0, 0.6],
                                               duration: 0.0,
                                               delegate: nil,
                                               timingFunctions: [self.easeInOut])
    let shrinkAnim = self.buildKeyFrameAnimation(keyPath: "strokeStart",
                                                 values: [0.0, 1.0],
                                                 keyTimes: [0.3, 1.0],
                                                 duration: 0.0,
                                                 delegate: nil,
                                                 timingFunctions: [self.easeInOut])
    let anim = self.buildAnimationGroup(animations: [growAnim, shrinkAnim],
                                        duration: self.rotationDelay)
    anim.repeatCount = Float.greatestFiniteMagnitude
    return anim
  }()
  lazy private var globalRotationAnimation: CAAnimation = {
    let rotate = self.buildKeyFrameAnimation(keyPath: "transform.rotation",
                                             values: [0.0, CGFloat.pi * 2.0],
                                             keyTimes: [0.0, 1.0],
                                             duration: self.rotationDelay,
                                             delegate: nil,
                                             timingFunctions: [self.easeInOut])
    rotate.repeatCount = Float.greatestFiniteMagnitude
    return rotate
  }()
  private var colorAnimation: CAAnimation?
  
  // *********************************************************************
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  
  // *********************************************************************
  // MARK: - UIActivityIndicatorView
  override func startAnimating() {
    super.startAnimating()
    clearAnimations()
    layer.add(globalRotationAnimation,
              forKey: "globalRotationAnimation")
    circleShape.add(circleAnimation,
                    forKey: "circleAnimation")
    
    if strokeColor == UIColor.clear
    || strokeColor == nil {
      addColorAnimation()
    }
  }
  
  override func stopAnimating() {
    circleShape.removeAllAnimations()
    layer.removeAllAnimations()
  }
  
  // *********************************************************************
  // MARK: - Private
  private func configure() {
    layer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }
    
    layer.addSublayer(circleShape)
    layer.backgroundColor = UIColor.clear.cgColor
    layer.masksToBounds = true
    startAnimating()
  }
  
  private func addColorAnimation() {
    removeColorAnimation()
    colorAnimation = buildKeyFrameAnimation(keyPath: "strokeColor",
                                            values: [colors.current(),
                                                     colors.next()],
                                            keyTimes: [0.0, 1.0],
                                            duration: rotationDelay,
                                            delegate: self,
                                            timingFunctions: [easeInOut])
    circleShape.add(colorAnimation!,
                    forKey: CircleActivityIndicator.ColorAnimation)
}
  
  private func removeColorAnimation() {
    circleShape.removeAnimation(forKey: CircleActivityIndicator.ColorAnimation)
  }
  
  private func clearAnimations() {
    layer.removeAllAnimations()
    circleShape.removeAllAnimations()
  }
  
  // *********************************************************************
  // MARK: - CAAnimationDelegate
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    if flag {
      addColorAnimation()
    }
  }
}
