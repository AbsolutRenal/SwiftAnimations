//
//  Animatable.swift
//  Animations
//
//  Created by AbsolutRenal on 20/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import QuartzCore

protocol Animatable: CAAnimationDelegate {
  func buildKeyFrameAnimation(keyPath: String,
                              values: [Any],
                              keyTimes: [NSNumber]?,
                              duration: CFTimeInterval,
                              delegate: CAAnimationDelegate?,
                              timingFunctions: [CAMediaTimingFunction]?) -> CAKeyframeAnimation
  func buildAnimationGroup(animations: [CAAnimation],
                           duration: CFTimeInterval,
                           delegate: CAAnimationDelegate?) -> CAAnimationGroup
}

extension Animatable {
  func buildKeyFrameAnimation(keyPath: String,
                              values: [Any],
                              keyTimes: [NSNumber]?,
                              duration: CFTimeInterval = 0,
                              delegate: CAAnimationDelegate? = nil,
                              timingFunctions: [CAMediaTimingFunction]? = nil) -> CAKeyframeAnimation {
    let anim = CAKeyframeAnimation(keyPath: keyPath)
    anim.values = values
    anim.keyTimes = keyTimes
    anim.delegate = delegate
    anim.fillMode = kCAFillModeForwards
    anim.timingFunctions = timingFunctions
    anim.duration = duration
    return anim
  }
  
  func buildAnimationGroup(animations: [CAAnimation],
                                   duration: CFTimeInterval,
                                   delegate: CAAnimationDelegate? = nil) -> CAAnimationGroup {
    let anim = CAAnimationGroup()
    anim.animations = animations
    anim.duration = duration
    anim.delegate = delegate
    anim.fillMode = kCAFillModeForwards
    return anim
  }
}
