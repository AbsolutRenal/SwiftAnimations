//
// Created by AbsolutRenal on 25/10/2017.
// Copyright (c) 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore

class AtomLikeView: UIView, Animatable {
  // *********************************************************************
  // MARK: - Constants
  private let kDuration:CFTimeInterval = 1.5
  private let kRotationAngle:CGFloat = .pi * 0.2
  private let kEasing = CAMediaTimingFunction(controlPoints: 0.5,
                                                 0,
                                                 0.5,
                                                 1)

  // *********************************************************************
  // MARK: - Properties
  lazy private var circle1: CALayer = {
    let circle = circleFactory(withFrame: layer.bounds,
                               color: UIColor(red: 108.0/255.0, green: 116.0/255.0, blue: 117.0/255.0, alpha: 1.0).cgColor,
                               borderWidth: 2.0)
    circle.zPosition = 0
    return circle
  }()
  lazy private var circle2: CALayer = {
    let circle = circleFactory(withFrame: layer.bounds,
                               color: UIColor(red: 5.0/255.0, green: 179.0/255.0, blue: 203.0/255.0, alpha: 1.0).cgColor,
                               borderWidth: 2.0)
    circle.zPosition = -1
    return circle
  }()
  lazy private var circle3: CALayer = {
    let circle = circleFactory(withFrame: layer.bounds,
                               color: UIColor(red: 222.0/255.0, green: 112.0/255.0, blue: 52.0/255.0, alpha: 1.0).cgColor,
                               borderWidth: 2.0)
    circle.zPosition = -2
    return circle
  }()

  // *********************************************************************
  // MARK: - LifeCycle
  
  // *********************************************************************
  // MARK: - Public methods
  func display() {
    layer.addSublayer(circle1)
    layer.addSublayer(circle2)
    layer.addSublayer(circle3)
    animate()
  }

  // *********************************************************************
  // MARK: - Private methods
  private func circleFactory(withFrame frame: CGRect, color: CGColor, borderWidth: CGFloat) -> CALayer {
    let l = CALayer()
    l.frame = frame
    l.cornerRadius = frame.size.width * 0.5
    l.borderWidth = borderWidth
    l.borderColor = color
    return l
  }

  private func animate() {
    clearAnimations()
    animateCircle1()
    animateCircle2()
    animateCircle3()
  }
  
  private func clearAnimations() {
    circle1.removeAllAnimations()
    circle2.removeAllAnimations()
    circle3.removeAllAnimations()
  }
  
  private func animateCircle1() {
    let startAngleY = CGFloat.pi * 0.5
    let finalAngleY = startAngleY + CGFloat.pi * 2
    let yRotation = buildKeyFrameAnimation(keyPath: "transform.rotation.y",
                                           values: [startAngleY, finalAngleY],
                                           keyTimes: [0.0, 1.0],
                                           duration: kDuration)
    yRotation.repeatCount = .greatestFiniteMagnitude
    yRotation.timingFunction = kEasing
    circle1.add(yRotation, forKey: "rotation")
    circle1.transform = CATransform3DRotate(circle1.transform,
                                            finalAngleY,
                                            0.0,
                                            1.0,
                                            0.0)
  }

  private func animateCircle2() {
    let startAngleY = CGFloat.pi * 0.5
    let finalAngleY = startAngleY + CGFloat.pi * 2
    let yRotation = buildKeyFrameAnimation(keyPath: "transform.rotation.y",
                                           values: [startAngleY, finalAngleY],
                                           keyTimes: [0.0, 1.0],
                                           duration: kDuration)
    let xRotation = buildKeyFrameAnimation(keyPath: "transform.rotation.x",
                                           values: [kRotationAngle, 0, kRotationAngle, 0, kRotationAngle],
                                           keyTimes: [0.0, 0.25, 0.5, 0.75, 1.0])
    let rotationAnim = buildAnimationGroup(animations: [xRotation, yRotation],
                                           duration: kDuration,
                                           fillMode: .forwards,
                                           beginTime: nil,
                                           delegate: nil)
    rotationAnim.timingFunction = kEasing
    rotationAnim.repeatCount = .greatestFiniteMagnitude
    circle2.add(rotationAnim, forKey: "rotation")
  }

  private func animateCircle3() {
    let startAngleY = CGFloat.pi * 0.5
    let finalAngleY = startAngleY + CGFloat.pi * 2
    let yRotation = buildKeyFrameAnimation(keyPath: "transform.rotation.y",
                                           values: [startAngleY, finalAngleY],
                                           keyTimes: [0.0, 1.0],
                                           duration: kDuration)
    let xRotation = buildKeyFrameAnimation(keyPath: "transform.rotation.x",
                                           values: [-kRotationAngle, 0, -kRotationAngle, 0, -kRotationAngle],
                                           keyTimes: [0.0, 0.25, 0.5, 0.75, 1.0])
    let rotationAnim = buildAnimationGroup(animations: [xRotation, yRotation],
                                           duration: kDuration,
                                           fillMode: .forwards,
                                           beginTime: nil,
                                           delegate: nil)
    rotationAnim.timingFunction = kEasing
    rotationAnim.repeatCount = .greatestFiniteMagnitude
    circle3.add(rotationAnim, forKey: "rotation")
  }
}
