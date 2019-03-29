//
//  ConnectionSearchView.swift
//  BeautifulAnimations
//
//  Created by AbsolutRenal on 26/10/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

final class ConnectionSearchView: UIView, Animatable {
  private enum AnimationState {
    case none
    case fadeIn
    case needleRotation(Int)
    case needleRotationMiddle
    case exclamationMark
    case fadeOut
    
    private static let rotationMaxCount = 3
    
    mutating func next() {
      switch self {
      case .fadeIn:
        self = .needleRotation(1)
      case .needleRotation(let nb):
        self = (nb < AnimationState.rotationMaxCount)
          ? .needleRotation(nb + 1)
          : .needleRotationMiddle
      case .needleRotationMiddle:
        self = .exclamationMark
      case .exclamationMark:
        self = .fadeOut
      case .fadeOut:
        self = .none
      case .none:
        self = .fadeIn
      }
    }
  }
  
  private enum RotationDirection {
    case left
    case right
  }
  
  private enum Constants {
    static let dotWidth: CGFloat = 12
    static let signalThickness: CGFloat = 5
    static let needleThickness: CGFloat = 5
    static let needleHeight: CGFloat = 36
    static let signalStartAngle: CGFloat = -.pi * 3 / 4
    static let signalMiddleAngle: CGFloat = -.pi * 2 / 4
    static let signalEndAngle: CGFloat = -.pi / 4
    static let signal1Radius: CGFloat = 14
    static let signal2Radius: CGFloat = 24
    static let signal3Radius: CGFloat = 34
    static let maskLayerThickness: CGFloat = 24
    static let needleRotationDuration: CFTimeInterval = 0.5
    static let signalRotationDelay: Double = 0.2
    static let needleRotationDelayBeforeNext: Double = 0.4
    static let needleRotationEase: CAMediaTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
    static let exclamationMarkFadeInDuration: CFTimeInterval = 0.4
    static let exclamationMarkFadeOutDuration: CFTimeInterval = 0.4
  }
  
  // MARK: - Properties
  private var dot: CALayer!
  private var maskedWiFiLayer: CALayer!
  private var maskLayer: CAShapeLayer!
  private var needleLayer: CALayer!
  private var exclamationMarkLayer: CAShapeLayer!
  private var state: AnimationState = .fadeIn
  private var isRunning = false
  
  // MARK: - LifeCycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUI()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
  }
  
  // MARK: - Public
  func startAnimation() {
    isRunning = true
    animateToNextState()
  }
  
  func stopAnimation() {
    isRunning = false
    layer.removeAllAnimations()
    dot.removeAllAnimations()
    needleLayer.removeAllAnimations()
    maskLayer.removeAllAnimations()
    exclamationMarkLayer.removeAllAnimations()
    state = .fadeIn
    resetState()
  }
  
  private func resetState() {
    dot.setValueDiscreetly(value: 0, forKeyPath: "opacity")
    needleLayer.setValueDiscreetly(value: 0, forKeyPath: "opacity")
    needleLayer.setValueDiscreetly(value: CATransform3DMakeRotation(Constants.signalStartAngle, 0, 0, 1), forKeyPath: "transform")
    maskLayer.setValueDiscreetly(value: 0, forKeyPath: "strokeStart")
    maskLayer.setValueDiscreetly(value: 0, forKeyPath: "strokeEnd")
    exclamationMarkLayer.setValueDiscreetly(value: 0, forKeyPath: "opacity")
    state = .fadeIn
  }
  
  // MARK: - Private
  private func setupUI() {
    backgroundColor = .clear
    setupWiFi()
  }
  
  private func setupWiFi() {
    let position = CGPoint(x: bounds.midX, y: bounds.midY)
    
    layer.addSublayer(WiFiLayer(with: UIColor.placeholderGray, position: position))
    maskedWiFiLayer = WiFiLayer(with: UIColor.black, position: position)
    layer.addSublayer(maskedWiFiLayer)
    
    maskLayer = WiFiMaskLayer(at: position)
    layer.addSublayer(maskLayer)
    
    maskedWiFiLayer.mask = maskLayer
    
    maskLayer.strokeStart = 0
    maskLayer.strokeEnd = 0
    dot = WiFiDotLayer(with: UIColor.black, position: position)
    dot.opacity = 0
    layer.addSublayer(dot)
    
    needleLayer = WiFiNeedleLayer(at: position)
    needleLayer.setAffineTransform(CGAffineTransform(rotationAngle: Constants.signalStartAngle))
    needleLayer.opacity = 0
    layer.addSublayer(needleLayer)
    
    exclamationMarkLayer = markLayer(at: position)
    exclamationMarkLayer.opacity = 0
    layer.addSublayer(exclamationMarkLayer)
  }
  
  private func WiFiDotLayer(with color: UIColor, position: CGPoint) -> CALayer {
    let size: CGFloat = Constants.dotWidth
    let dotLayer = CALayer()
    dotLayer.backgroundColor = color.cgColor
    dotLayer.cornerRadius = size * 0.5
    dotLayer.frame = CGRect(x: position.x - size * 0.5, y: position.y - size * 0.5, width: size, height: size)
    return dotLayer
  }
  
  private func WiFiNeedleLayer(at position: CGPoint) -> CALayer {
    let thickness: CGFloat = Constants.needleThickness
    let height: CGFloat = Constants.needleHeight
    let layer = CALayer()
    layer.backgroundColor = UIColor.black.cgColor
    layer.anchorPoint = CGPoint(x: 0, y: 0.5)
    layer.frame = CGRect(x: position.x, y: position.y - thickness * 0.5, width: height, height: thickness)
    return layer
  }
  
  private func WiFiLayer(with color: UIColor, position: CGPoint) -> CALayer {
    let layer = CALayer()
    
    layer.addSublayer(WiFiDotLayer(with: color, position: position))
    layer.addSublayer(wiFiSignalLayer(with: Constants.signal1Radius, position: position, color: color))
    layer.addSublayer(wiFiSignalLayer(with: Constants.signal2Radius, position: position, color: color))
    layer.addSublayer(wiFiSignalLayer(with: Constants.signal3Radius, position: position, color: color))
    return layer
  }
  
  private func wiFiSignalLayer(with radius: CGFloat, position: CGPoint, color: UIColor) -> CAShapeLayer {
    let pathLayer = CAShapeLayer()
    pathLayer.path = bezierPath(at: position, radius: radius).cgPath
    pathLayer.fillColor = UIColor.clear.cgColor
    pathLayer.strokeColor = color.cgColor
    pathLayer.lineCap = .square
    pathLayer.lineWidth = Constants.signalThickness
    return pathLayer
  }
  
  private func WiFiMaskLayer(at position: CGPoint) -> CAShapeLayer {
    let maskLayer = CAShapeLayer()
    maskLayer.path = bezierPath(at: position, radius: Constants.signal2Radius).cgPath
    maskLayer.fillColor = UIColor.clear.cgColor
    maskLayer.lineWidth = Constants.maskLayerThickness
    maskLayer.strokeColor = UIColor.black.cgColor
    return maskLayer
  }
  
  private func bezierPath(at position: CGPoint, radius: CGFloat) -> UIBezierPath {
    return UIBezierPath(arcCenter: position,
                        radius: radius,
                        startAngle: Constants.signalStartAngle, endAngle: Constants.signalEndAngle,
                        clockwise: true)
  }
  
  private func markLayer(at position: CGPoint) -> CAShapeLayer {
    let markLayer = CAShapeLayer()
    markLayer.backgroundColor = UIColor.black.cgColor
    let path = UIBezierPath()
    path.move(to: CGPoint(x: position.x - 4, y: position.y - Constants.signal3Radius - Constants.signalThickness * 0.5))
    path.addLine(to: CGPoint(x: position.x + 4, y: position.y - Constants.signal3Radius - Constants.signalThickness * 0.5))
    path.addLine(to: CGPoint(x: position.x + 2, y: position.y - Constants.signal1Radius + Constants.signalThickness * 0.5))
    path.addLine(to: CGPoint(x: position.x - 2, y: position.y - Constants.signal1Radius + Constants.signalThickness * 0.5))
    path.move(to: CGPoint(x: position.x - 4, y: position.y - Constants.signal3Radius - Constants.signalThickness * 0.5))
    markLayer.path = path.cgPath
    markLayer.backgroundColor = UIColor.black.cgColor
    return markLayer
  }
  
  private func fadeIn() {
    needleLayer.setValueDiscreetly(value: CATransform3DMakeRotation(Constants.signalStartAngle, 0, 0, 1), forKeyPath: "transform")
    let fadeInAnimation = buildKeyFrameAnimation(keyPath: "opacity",
                                                 values: [0, 1], keyTimes: [0, 1],
                                                 duration: 0.3, fillMode: .forwards,
                                                 delegate: nil, timingFunctions: nil)
    dot.add(fadeInAnimation, forKey: "fadeIn")
    fadeInAnimation.delegate = self
    needleLayer.add(fadeInAnimation, forKey: "fadeIn")
    dot.setValueDiscreetly(value: 1, forKeyPath: "opacity")
    needleLayer.setValueDiscreetly(value: 1, forKeyPath: "opacity")
  }
  
  private func rotateNeedle(_ direction: RotationDirection) {
    let startAngle: CGFloat = (direction == .right) ? Constants.signalStartAngle : Constants.signalEndAngle
    let endAngle: CGFloat = (direction == .right) ? Constants.signalEndAngle : Constants.signalStartAngle
    let strokeStart: CGFloat = (direction == .right) ? 0 : 1
    let strokeEnd: CGFloat = (direction == .right) ? 1 : 0
    let duration: CFTimeInterval = Constants.needleRotationDuration + Constants.needleRotationDelayBeforeNext
    let endTime = NSNumber(value: 1 - Constants.signalRotationDelay - Constants.needleRotationDelayBeforeNext)
    let needleRotationAnimation = buildKeyFrameAnimation(keyPath: "transform.rotation.z",
                                                         values: [startAngle, endAngle],
                                                         keyTimes: [0, endTime],
                                                         duration: duration,
                                                         fillMode: .forwards,
                                                         delegate: self,
                                                         timingFunctions: [Constants.needleRotationEase])
    needleLayer.add(needleRotationAnimation, forKey: "rotation")
    
    let signalStartKeyTimes: [NSNumber] = direction == .right
      ? [NSNumber(value: Constants.signalRotationDelay), NSNumber(value: 1 - Constants.needleRotationDelayBeforeNext)]
      : [0, endTime]
    let signalEndKeyTimes: [NSNumber] = direction == .right
      ? [0, endTime]
      : [NSNumber(value: Constants.signalRotationDelay), NSNumber(value: 1 - Constants.needleRotationDelayBeforeNext)]
    
    let layerMaskAnimationStart = buildKeyFrameAnimation(keyPath: "strokeStart",
                                                         values: [strokeStart, strokeEnd],
                                                         keyTimes: signalStartKeyTimes,
                                                         timingFunctions: [Constants.needleRotationEase])
    let layerMaskAnimationEnd = buildKeyFrameAnimation(keyPath: "strokeEnd",
                                                       values: [strokeStart, strokeEnd],
                                                       keyTimes: signalEndKeyTimes,
                                                       timingFunctions: [Constants.needleRotationEase])
    let layerMaskAnimation = buildAnimationGroup(animations: [layerMaskAnimationStart, layerMaskAnimationEnd],
                                                 duration: duration,
                                                 fillMode: .forwards,
                                                 delegate: nil)
    maskLayer.add(layerMaskAnimation, forKey: "animateStroke")
    
    needleLayer.setValueDiscreetly(value: endAngle, forKeyPath: "transform.rotation.z")
    maskLayer.setValueDiscreetly(value: strokeEnd, forKeyPath: "strokeStart")
    maskLayer.setValueDiscreetly(value: strokeEnd, forKeyPath: "strokeEnd")
  }
  
  private func rotateToMiddle() {
    let endAngle = (Constants.signalEndAngle + Constants.signalStartAngle) * 0.5
    let needleRotationAnimation = buildKeyFrameAnimation(keyPath: "transform.rotation.z",
                                                         values: [Constants.signalEndAngle, endAngle],
                                                         keyTimes: [0, 1],
                                                         duration: Constants.needleRotationDuration * 0.5,
                                                         fillMode: .forwards,
                                                         delegate: self,
                                                         timingFunctions: [Constants.needleRotationEase])
    needleLayer.add(needleRotationAnimation, forKey: "rotation")
    needleLayer.setValueDiscreetly(value: endAngle, forKeyPath: "transform.rotation.z")
  }
  
  private func displayExclamationMark() {
    let fadeOutAnimation = buildKeyFrameAnimation(keyPath: "opacity",
                                                 values: [1, 0], keyTimes: [0, 1],
                                                 duration: Constants.exclamationMarkFadeInDuration, fillMode: .forwards,
                                                 delegate: nil, timingFunctions: nil)
    needleLayer.add(fadeOutAnimation, forKey: "fadeOut")
    needleLayer.setValueDiscreetly(value: 0, forKeyPath: "opacity")
    
    let fadeInAnimation = buildKeyFrameAnimation(keyPath: "opacity",
                                                 values: [0, 1], keyTimes: [0, 1],
                                                 duration: Constants.exclamationMarkFadeInDuration, fillMode: .forwards,
                                                 delegate: self, timingFunctions: nil)
    exclamationMarkLayer.add(fadeInAnimation, forKey: "fadeIn")
    exclamationMarkLayer.setValueDiscreetly(value: 1, forKeyPath: "opacity")
  }
  
  private func fadeOut() {
    let fadeOutAnimation = buildKeyFrameAnimation(keyPath: "opacity",
                                                  values: [1, 0], keyTimes: [0, 1],
                                                  duration: Constants.exclamationMarkFadeOutDuration, fillMode: .forwards,
                                                  delegate: self, timingFunctions: nil)
    exclamationMarkLayer.add(fadeOutAnimation, forKey: "fadeOut")
    exclamationMarkLayer.setValueDiscreetly(value: 0, forKeyPath: "opacity")
    dot.add(fadeOutAnimation, forKey: "fadeOut")
    dot.setValueDiscreetly(value: 0, forKeyPath: "opacity")
  }
  
  private func animateToNextState() {
    switch state {
    case .fadeIn: fadeIn()
    case .needleRotation(let nb): rotateNeedle(((nb % 2) == 1) ? .right : .left)
    case .needleRotationMiddle: rotateToMiddle()
    case.exclamationMark: displayExclamationMark()
    case .fadeOut:
      sleep(1)
      fadeOut()
    case .none: sleep(1)
    }
    state.next()
  }
}

extension ConnectionSearchView: CAAnimationDelegate {
  public func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    guard flag && isRunning else {
      return
      
    }
    animateToNextState()
  }
}

extension UIColor {
  static let placeholderGray = UIColor(red: 212/255.0,
                                       green: 212/255.0,
                                       blue: 212/255.0, alpha: 1.0)
}
