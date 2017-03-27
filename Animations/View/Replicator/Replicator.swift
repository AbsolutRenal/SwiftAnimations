//
//  Replicator.swift
//  Animations
//
//  Created by AbsolutRenal on 27/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class Replicator: UIView, Animatable {
  // *********************************************************************
  // MARK: - Constants
  private let nbLayers = 20
  private let ease = CAMediaTimingFunction(controlPoints: 0.6, 0.0, 0.6, 1.0)
  
  // *********************************************************************
  // MARK: - IBOutlets
  
  // *********************************************************************
  // MARK: - Properties
  var replicatorLayer: CAReplicatorLayer!
  private var size: CGFloat = 0
  
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
    let offset = 2
    size = (layer.bounds.size.width - CGFloat(nbLayers * offset)) / CGFloat(nbLayers)
    let l = CALayer()
    l.bounds = CGRect(x: 0,
                      y: 0,
                      width: size,
                      height: size)
    l.position = CGPoint(x: size * 0.5 + CGFloat(offset),
                         y: size * 0.5 + CGFloat(offset))
    l.backgroundColor = UIColor.lightGray.cgColor
    l.cornerRadius = 0.0
    
    let replicatorLayerX = CAReplicatorLayer()
    replicatorLayerX.preservesDepth = false
//    replicatorLayerX.instanceAlphaOffset = -0.05
    replicatorLayerX.instanceRedOffset = -0.01
    replicatorLayerX.instanceGreenOffset = -0.07
    replicatorLayerX.instanceBlueOffset = -0.04
    replicatorLayerX.instanceCount = nbLayers
    replicatorLayerX.instanceDelay = 0.05
    replicatorLayerX.instanceTransform = CATransform3DTranslate(CATransform3DIdentity,
                                                                size + CGFloat(offset),
                                                                0,
                                                                0)
    replicatorLayerX.addSublayer(l)
    
    let replicatorLayerY = CAReplicatorLayer()
    replicatorLayerY.preservesDepth = false
//    replicatorLayerY.instanceAlphaOffset = -0.08
    replicatorLayerY.instanceCount = Int(bounds.size.height / (size + CGFloat(offset)))
    replicatorLayerY.instanceDelay = 0.1
    replicatorLayerY.instanceRedOffset = -0.1
    replicatorLayerY.instanceGreenOffset = -0.03
    replicatorLayerY.instanceBlueOffset = -0.02
    replicatorLayerY.instanceTransform = CATransform3DTranslate(CATransform3DIdentity,
                                                                0,
                                                                size + CGFloat(offset),
                                                                0)
    replicatorLayerY.addSublayer(replicatorLayerX)
    
    layer.addSublayer(replicatorLayerY)
    
    let morph = morphAnimation()
    morph.repeatCount = Float.greatestFiniteMagnitude
    morph.autoreverses = true
    l.add(morph,
          forKey: "morph")
  }
  
  private func morphAnimation() -> CAAnimationGroup {
    let radius = buildKeyFrameAnimation(keyPath: "cornerRadius",
                                        values: [0.0, size * 0.5],
                                        keyTimes: [0.0, 0.6],
                                        duration: 0.0,
                                        delegate: nil,
                                        timingFunctions: [ease])
    let scale = buildKeyFrameAnimation(keyPath: "transform.scale",
                                       values: [1.0, 0.4],
                                       keyTimes: [0.0, 1.0],
                                       duration: 0.0,
                                       delegate: nil,
                                       timingFunctions: [ease])
    let anim = buildAnimationGroup(animations: [radius, scale],
                                   duration: 1.0)
    return anim
  }
}
