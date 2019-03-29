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
                              repeatDuration: CFTimeInterval,
                              fillMode: CAMediaTimingFillMode?,
                              beginTime: CFTimeInterval?,
                              delegate: CAAnimationDelegate?,
                              timingFunctions: [CAMediaTimingFunction]?) -> CAKeyframeAnimation
  func buildAnimationGroup(animations: [CAAnimation],
                           duration: CFTimeInterval,
                           repeatDuration: CFTimeInterval,
                           fillMode: CAMediaTimingFillMode?,
                           beginTime: CFTimeInterval?,
                           delegate: CAAnimationDelegate?) -> CAAnimationGroup
}

extension Animatable {
  func buildKeyFrameAnimation(keyPath: String,
                              values: [Any],
                              keyTimes: [NSNumber]?,
                              duration: CFTimeInterval = 0,
                              repeatDuration: CFTimeInterval = 0,
                              fillMode: CAMediaTimingFillMode? = nil,
                              beginTime: CFTimeInterval? = nil,
                              delegate: CAAnimationDelegate? = nil,
                              timingFunctions: [CAMediaTimingFunction]? = nil) -> CAKeyframeAnimation {
    let anim = CAKeyframeAnimation(keyPath: keyPath)
    anim.values = values
    anim.keyTimes = keyTimes
    anim.delegate = delegate
    anim.beginTime = beginTime ?? 0.0
    anim.fillMode = fillMode ?? .forwards
    anim.timingFunctions = timingFunctions
    anim.duration = duration
    anim.repeatDuration = repeatDuration
    return anim
  }
  
  func buildAnimationGroup(animations: [CAAnimation],
                           duration: CFTimeInterval,
                           repeatDuration: CFTimeInterval = 0,
                           fillMode: CAMediaTimingFillMode? = nil,
                           beginTime: CFTimeInterval? = nil,
                           delegate: CAAnimationDelegate? = nil) -> CAAnimationGroup {
    let anim = CAAnimationGroup()
    anim.animations = animations
    anim.duration = duration
    anim.repeatDuration = repeatDuration
    anim.delegate = delegate
    anim.beginTime = beginTime ?? 0.0
    anim.fillMode = fillMode ?? .forwards
    return anim
  }
}
