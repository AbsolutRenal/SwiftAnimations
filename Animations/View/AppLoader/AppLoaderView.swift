//
//  AppLoaderView.swift
//  Animations
//
//  Created by AbsolutRenal on 14/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class AppLoaderView: UIView, Animatable {
  // MARK: - Constants
  private enum Constants {
    static let particleSize: CGFloat = 16
    static let minInstancesOffset: CGFloat = 4
    static let upHeightRatio: CGFloat = 3
    static let downHeightRatio: CGFloat = 2
    
    enum Easing {
      static let easeInOut = CAMediaTimingFunction(controlPoints: 0.25, 0, 0.25, 1)
      static let easeInOutSlow = CAMediaTimingFunction(controlPoints: 0.45, 0, 0.1, 1)
      static let easeOut = CAMediaTimingFunction(controlPoints: 0, 0.5, 0.6, 1)
      static let easeIn = CAMediaTimingFunction(controlPoints: 0.5, 0, 1, 0.6)
    }
    enum KeyTimes {
      static let startsBottom: NSNumber = 0.5
      static let endsTop: NSNumber = 0.65
    }
  }
  
  // MARK: - Properties
  private var replicatorLayer: CAReplicatorLayer?
  lazy private var particle: CALayer = {
    let l = CALayer()
    l.backgroundColor = UIColor.white.cgColor
    l.bounds = CGRect(x: 0, y: 0, width: Constants.particleSize, height: Constants.particleSize)
    l.cornerRadius = Constants.particleSize * 0.5
    l.add(bounceAnimation, forKey: "bounce")
    return l
  }()
  private var bounceAnimation: CAAnimation {
    let offset = Constants.particleSize * 0.5
    let translationAnimation = buildKeyFrameAnimation(keyPath: "position.y",
                                                      values: [bounds.maxY - offset,
                                                               bounds.maxY - offset,
                                                               bounds.minY + offset,
                                                               bounds.maxY - offset],
                                                      keyTimes: [0,
                                                                 Constants.KeyTimes.startsBottom,
                                                                 Constants.KeyTimes.endsTop,
                                                                 1],
                                                      timingFunctions: [CAMediaTimingFunction(name: .linear),
                                                                        Constants.Easing.easeInOut,
                                                                        Constants.Easing.easeIn])
    let colorAnimation = buildKeyFrameAnimation(keyPath: "backgroundColor",
                                                values: [UIColor.white.cgColor,
                                                         UIColor.white.cgColor,
                                                         UIColor.pinkAppLoader.cgColor,
                                                         UIColor.white.cgColor],
                                                keyTimes: [0,
                                                           Constants.KeyTimes.startsBottom,
                                                           Constants.KeyTimes.endsTop,
                                                           1],
                                                timingFunctions: [CAMediaTimingFunction(name: .linear),
                                                                  Constants.Easing.easeOut,
                                                                  Constants.Easing.easeIn])
    let heightAnimation = buildKeyFrameAnimation(keyPath: "bounds.size.height",
                                                 values: [Constants.particleSize,
                                                          Constants.particleSize,
                                                          Constants.particleSize * Constants.upHeightRatio,
                                                          Constants.particleSize,
                                                          Constants.particleSize * Constants.downHeightRatio,
                                                          Constants.particleSize],
                                                 keyTimes: [0,
                                                            Constants.KeyTimes.startsBottom,
                                                            NSNumber(value: Constants.KeyTimes.startsBottom.floatValue + (Constants.KeyTimes.endsTop.floatValue - Constants.KeyTimes.startsBottom.floatValue) * 0.5),
                                                            Constants.KeyTimes.endsTop,
                                                            NSNumber(value: Constants.KeyTimes.endsTop.floatValue + (1 - Constants.KeyTimes.endsTop.floatValue) * 0.5),
                                                            1],
                                                 timingFunctions: [CAMediaTimingFunction(name: .linear),
                                                                   Constants.Easing.easeInOutSlow,
                                                                   Constants.Easing.easeOut])
    let animation = buildAnimationGroup(animations: [translationAnimation, colorAnimation, heightAnimation],
                                        duration: 1.5)
    animation.repeatCount = .greatestFiniteMagnitude
    return animation
  }
  
  // MARK: - LifeCycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    clearReplicator()
    setupReplicator()
  }
  
  // MARK: - Private
  private func setup() {
    backgroundColor = .clear
  }
  
  private func clearReplicator() {
    guard let replicator = replicatorLayer else {
      return
    }
    replicator.removeAllAnimations()
    replicator.removeFromSuperlayer()
  }
  
  private func setupReplicator() {
    let instanceCount = Int(bounds.width / (Constants.particleSize + Constants.minInstancesOffset))
    particle.position = CGPoint(x: Constants.particleSize * 0.5, y: bounds.maxY - Constants.particleSize * 0.5)
    let offset = (bounds.width - Constants.particleSize * CGFloat(instanceCount)) / (CGFloat(instanceCount) - 1)
    
    replicatorLayer = CAReplicatorLayer()
    replicatorLayer?.instanceCount = instanceCount
    replicatorLayer?.instanceDelay = 0.06
    replicatorLayer?.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, Constants.particleSize + offset, 0, 0)
    replicatorLayer?.addSublayer(particle)
    layer.addSublayer(replicatorLayer!)
  }
}

extension UIColor {
  static let pinkAppLoader = UIColor(fullRed: 220, fullGreen: 54, fullBlue: 233, alpha: 1)
  
  convenience init(fullRed: CGFloat, fullGreen: CGFloat, fullBlue: CGFloat, alpha: CGFloat) {
    self.init(red: fullRed / 255.0, green: fullGreen / 255.0, blue: fullBlue / 255.0, alpha: alpha)
  }
}
