//
//  PulseReplicator.swift
//  Animations
//
//  Created by AbsolutRenal on 28/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class PulseReplicator: UIView, Animatable {
  // *********************************************************************
  // MARK: - Constants
  private let particuleSize = 60
  private let growEasing = CAMediaTimingFunction(controlPoints: 0.6, 0, 0.6, 1.6)
  
  // *********************************************************************
  // MARK: - Properties
  
  // *********************************************************************
  // MARK: - IBOutlets
  
  // *********************************************************************
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  
  // *********************************************************************
  // MARK: - Private
  private func configure() {
    create()
  }
  
  private func create() {
    clipsToBounds = true
    
    let particule = CALayer()
    particule.backgroundColor = UIColor.lightGray.cgColor
    particule.bounds = CGRect(x: 0,
                              y: 0,
                              width: particuleSize,
                              height: particuleSize)
    particule.cornerRadius = CGFloat(particuleSize) * 0.5
    particule.shadowOffset = CGSize(width: 1,
                                    height: 1)
    particule.position = CGPoint(x: layer.bounds.size.width * 0.5,
                                 y: layer.bounds.size.height * 0.5)
    particule.add(pulseAnimation(),
                  forKey: "pulse")
    layer.addSublayer(particule)
    
    let scaleReplicator = CAReplicatorLayer()
    scaleReplicator.instanceBlueOffset = -0.1
    scaleReplicator.instanceRedOffset = -0.1
    scaleReplicator.instanceGreenOffset = -0.1
    scaleReplicator.instanceCount = 50
    scaleReplicator.instanceDelay = 0.1
    scaleReplicator.bounds = layer.bounds
    scaleReplicator.position = particule.position
    scaleReplicator.instanceTransform = CATransform3DScale(CATransform3DIdentity,
                                                           0.9,
                                                           0.9,
                                                           1.0)
    scaleReplicator.addSublayer(particule)
    scaleReplicator.shadowRadius = 1.0
    scaleReplicator.shadowOpacity = 0.3
    layer.addSublayer(scaleReplicator)
  }
  
  private func pulseAnimation() -> CAAnimationGroup {
    let grow = buildKeyFrameAnimation(keyPath: "transform.scale",
                                      values: [1.0, 1.4],
                                      keyTimes: [0.0, 0.8],
                                      duration: 0.0,
                                      delegate: nil,
                                      timingFunctions: [growEasing])
    let color = buildKeyFrameAnimation(keyPath: "backgroundColor",
                                       values: [UIColor(red: 160.0/255.0,
                                                        green: 0.0,
                                                        blue: 0.0,
                                                        alpha: 1.0).cgColor,
                                                UIColor.red.cgColor],
                                       keyTimes: [0.3, 1.0],
                                       duration: 0.0,
                                       delegate: nil,
                                       timingFunctions: [growEasing])
    
    let anim = buildAnimationGroup(animations: [grow, color],
                                   duration: 1.0,
                                   delegate: nil)
    anim.autoreverses = true
    anim.repeatCount = Float.greatestFiniteMagnitude
    return anim
  }
}
