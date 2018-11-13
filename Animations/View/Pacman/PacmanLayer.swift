//
// Created by AbsolutRenal on 30/10/2017.
// Copyright (c) 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

class PacmanLayer: CAShapeLayer, Animatable {
  // *********************************************************************
  // MARK: - Constants
  fileprivate let kGumRadius: CGFloat = 4
  fileprivate let kGumInstances: Int = 3
  fileprivate let kGumDelay: CFTimeInterval = 0.5
  fileprivate let kGumAnimtionDuration: CFTimeInterval = 1
  fileprivate let kGumAnimationKey: String = "GumAnimation"
  fileprivate let kAngleMax: CGFloat = .pi / 3
  fileprivate let kAnglePitch: CGFloat = 0.05
  fileprivate let kTimerInterval: TimeInterval = 0.01

  // *********************************************************************
  // MARK: - Properties
  fileprivate var angle: CGFloat = 0
  fileprivate var sign: CGFloat = 1
  lazy fileprivate var loop: Timer = {
    let t = Timer.scheduledTimer(timeInterval: kTimerInterval,
                                 target: self,
                                 selector: #selector(redraw),
                                 userInfo: nil,
                                 repeats: true)
    return t
  }()

  lazy fileprivate var pacGum: CALayer = {
    let l = CALayer()
    l.frame = CGRect(x: bounds.width - kGumRadius,
                     y: (bounds.height - kGumRadius) * 0.5,
                     width: kGumRadius,
                     height: kGumRadius)
    l.backgroundColor = UIColor.yellow.cgColor
    l.cornerRadius = kGumRadius * 0.5
    l.opacity = 0.0
    l.add(pacGumAnim,
          forKey: kGumAnimationKey)
    return l
  }()
  lazy fileprivate var pacGumAnim: CAAnimation = {
    let translation = buildKeyFrameAnimation(keyPath: "transform.translation.x",
                                             values: [0.0, -bounds.width + bounds.height * 0.5],
                                             keyTimes: [0.0, 1.0])
    let fadeIn = buildKeyFrameAnimation(keyPath: "opacity",
                                        values: [0.0, 1.0],
                                        keyTimes: [0.0, 0.1])
    let anim = buildAnimationGroup(animations: [translation, fadeIn],
                                   duration: kGumAnimtionDuration,
                                   repeatDuration: 0,
                                   fillMode: kCAFillModeForwards,
                                   beginTime: nil,
                                   delegate: nil)
    anim.repeatCount = .greatestFiniteMagnitude
    return anim
  }()
  lazy fileprivate var pacGumReplicator: CAReplicatorLayer = {
    let l = CAReplicatorLayer()
    l.instanceCount = kGumInstances
    l.instanceDelay = kGumDelay
    l.addSublayer(pacGum)
    return l
  }()

  // *********************************************************************
  // MARK: - Lifecycle
  required init(withFrame frame: CGRect) {
    super.init()
    self.frame = frame
    backgroundColor = UIColor.clear.cgColor
    fillColor = UIColor.yellow.cgColor
    addSublayer(pacGumReplicator)
    loop.fire()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("Should use init(withFrame:)")
  }

  override func draw(in ctx: CGContext) {
    if angle >= kAngleMax
       || angle == 0 {
      sign *= -1
    }
    angle = max(angle + sign * kAnglePitch, 0)
    let halfSize = frame.height * 0.5
    path = pacmanMouthPath(withCenter: CGPoint(x: halfSize, y: halfSize),
                           radius: halfSize,
                           angle: angle,
                           context: ctx)
  }

  // *********************************************************************
  // MARK: - Public methods
  @objc public func redraw() {
    setNeedsDisplay()
  }

  public func stop() {
    loop.invalidate()
    removeAllAnimations()
  }

  // *********************************************************************
  // MARK: - Private methods
  fileprivate func pacmanMouthPath(withCenter center: CGPoint,
                                   radius: CGFloat,
                                   angle: CGFloat,
                                   context: CGContext) -> CGPath? {
    context.beginPath()
    context.move(to: center)
    context.addArc(center: center,
                   radius: radius,
                   startAngle: .pi * 2 - angle * 0.5,
                   endAngle: angle * 0.5,
                   clockwise: true)
    context.closePath()
    return context.path
  }
}
