//
// Created by AbsolutRenal on 25/10/2017.
// Copyright (c) 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class SquareReplicatorLoaderView: UIView, Animatable {
  // *********************************************************************
  // MARK: - Constants
  fileprivate let kFadeKey = "fade"
  fileprivate let kFadeDuration: CFTimeInterval = 0.3
  fileprivate let kAnimationKey = "loadingAnimation"
  fileprivate let kInstanceCount = 3
  fileprivate let kAnimationDuration: CFTimeInterval = 0.8
  fileprivate let kInstanceDelay: CFTimeInterval = 0.12
  fileprivate let kEasing = CAMediaTimingFunction(controlPoints: 0.3,
                                                  0,
                                                  0.7,
                                                  1.0)

  // *********************************************************************
  // MARK: - Properties
  var isLoading = false
  lazy fileprivate var tileSize: CGFloat = {
    return bounds.width / CGFloat(kInstanceCount)
  }()
  lazy fileprivate var tile: CALayer = {
    let l = CALayer()
    l.frame = CGRect(x: 0,
                     y: bounds.maxY - tileSize,
                     width: tileSize,
                     height: tileSize)
    l.backgroundColor = UIColor.white.cgColor
    return l
  }()
  lazy fileprivate var replicatorX: CAReplicatorLayer = {
    let replicator = CAReplicatorLayer()
    replicator.instanceCount = kInstanceCount
    replicator.instanceTransform = CATransform3DTranslate(CATransform3DIdentity,
                                                          tileSize,
                                                          0,
                                                          -1)
    replicator.instanceDelay = kInstanceDelay
    return replicator
  }()
  lazy fileprivate var replicatorY: CAReplicatorLayer = {
    let replicator = CAReplicatorLayer()
    replicator.instanceCount = kInstanceCount
    replicator.instanceTransform = CATransform3DTranslate(CATransform3DIdentity,
                                                          0,
                                                          -tileSize,
                                                          -1)
    replicator.instanceDelay = kInstanceDelay
    return replicator
  }()
  lazy fileprivate var animation: CAAnimation = {
    let anim = buildKeyFrameAnimation(keyPath: "transform.scale",
                                      values: [1.0, 1.0, 0.0],
                                      keyTimes: [0.0, 0.35, 1.0],
                                      duration: kAnimationDuration,
                                      repeatDuration: 0,
                                      fillMode: .forwards,
                                      beginTime: nil,
                                      delegate: nil,
                                      timingFunctions: nil)
    anim.timingFunction = kEasing
    anim.repeatCount = .greatestFiniteMagnitude
    anim.autoreverses = true
    return anim
  }()

  // *********************************************************************
  // MARK: - Public methods
  func startLoading() {
    guard !isLoading else {
      return
    }
    layer.opacity = 0
    isLoading = true
    replicatorX.addSublayer(tile)
    replicatorY.addSublayer(replicatorX)
    layer.addSublayer(replicatorY)
    tile.add(animation, forKey: kAnimationKey)
    
    let fadeIn = buildKeyFrameAnimation(keyPath: "opacity",
                                        values: [0.0, 1.0],
                                        keyTimes: [0.0, 1.0],
                                        duration: kFadeDuration,
                                        repeatDuration: 0,
                                        fillMode: .forwards,
                                        beginTime: nil,
                                        delegate: nil,
                                        timingFunctions: nil)
    layer.add(fadeIn, forKey: kFadeKey)
    layer.opacity = 1
  }

  func stopLoading() {
    let fadeOut = buildKeyFrameAnimation(keyPath: "opacity",
                                         values: [1.0, 0.0],
                                         keyTimes: [0.0, 1.0],
                                         duration: kFadeDuration,
                                         repeatDuration: 0,
                                         fillMode: .forwards,
                                         beginTime: nil,
                                         delegate: self,
                                         timingFunctions: nil)
    layer.add(fadeOut, forKey: kFadeKey)
    layer.opacity = 0
  }
  
  // *********************************************************************
  // MARK: - Private methods
  fileprivate func clearLoader() {
    layer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }
  }
  
  // *********************************************************************
  // MARK: - CAAnimationDelegate
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    layer.removeAllAnimations()
    tile.removeAllAnimations()
    clearLoader()
    isLoading = false
  }
}
