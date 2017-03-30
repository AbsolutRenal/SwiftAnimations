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
  private let particuleSize = 20
  private let rotationCount = 65
  private let duplicateCount = 12
  private let growEasing = CAMediaTimingFunction(controlPoints: 0.6, 0, 0.6, 1.2)
  
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
    addPerspective()
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
    
    let translateReplicator = CAReplicatorLayer()
    translateReplicator.instanceBlueOffset = -0.1
    translateReplicator.instanceRedOffset = -0.1
    translateReplicator.instanceGreenOffset = -0.1
    translateReplicator.instanceCount = duplicateCount
    translateReplicator.instanceDelay = 0.1
    translateReplicator.instanceTransform = CATransform3DTranslate(CATransform3DIdentity,
                                                                   CGFloat(particuleSize),
                                                                   0,
                                                                   0)
    translateReplicator.addSublayer(particule)
    translateReplicator.bounds = CGRect(x: (layer.bounds.size.width - CGFloat(particuleSize)) * 0.5,
                                        y: (layer.bounds.size.height - CGFloat(particuleSize)) * 0.5,
                                        width: layer.bounds.size.width * 0.8,
                                        height: CGFloat(particuleSize))
    translateReplicator.masksToBounds = true
    let anchorX = (CGFloat(particuleSize) * 0.5) / translateReplicator.bounds.size.width
    translateReplicator.anchorPoint = CGPoint(x: anchorX,
                                              y: 0.5)
    
    let rotateReplicator = CAReplicatorLayer()
    rotateReplicator.instanceCount = rotationCount
    rotateReplicator.instanceTransform = CATransform3DRotate(CATransform3DIdentity,
                                                             CGFloat(2 * Double.pi / Double(rotationCount)),
                                                             0,
                                                             0,
                                                             1)
    rotateReplicator.addSublayer(translateReplicator)
    rotateReplicator.position = CGPoint(x: layer.bounds.size.width * 0.5,
                                        y: layer.bounds.size.height * 0.5)
    rotateReplicator.shadowRadius = 1.0
    rotateReplicator.shadowOpacity = 0.3
    layer.addSublayer(rotateReplicator)
  }
  
  private func addPerspective() {
    var perspective = CATransform3DIdentity
    perspective.m34 = -1.0 / 100.0
    layer.sublayerTransform = perspective
  }
  
  private func pulseAnimation() -> CAAnimationGroup {
    let grow = buildKeyFrameAnimation(keyPath: "transform.scale",
                                      values: [1.0, 1.8],
                                      keyTimes: [0.2, 1.0],
                                      duration: 0.8,
                                      delegate: nil,
                                      timingFunctions: [growEasing])
    let depth = buildKeyFrameAnimation(keyPath: "zPosition",
                                       values: [1000.0, -1000.0],
                                       keyTimes: [0.0, 0.4],
                                       duration: 0.8,
                                       delegate: nil,
                                       timingFunctions: [growEasing])
    
    let anim = buildAnimationGroup(animations: [grow, depth],
                                   duration: 0.8,
                                   delegate: nil)
    anim.autoreverses = true
    anim.repeatCount = Float.greatestFiniteMagnitude
    return anim
  }
}
