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
  private let particleSize: CGFloat = 16
  private let minInstancesOffset: CGFloat = 4
  
  // MARK: - Properties
  private var replicatorLayer: CAReplicatorLayer?
  lazy private var particle: CALayer = {
    let l = CALayer()
    l.backgroundColor = UIColor.white.cgColor
    l.bounds = CGRect(x: 0, y: 0, width: particleSize, height: particleSize)
    l.cornerRadius = particleSize * 0.5
    return l
  }()
  
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
    backgroundColor = UIColor.red
  }
  
  private func clearReplicator() {
    guard let replicator = replicatorLayer else {
      return
    }
    replicator.removeAllAnimations()
    replicator.removeFromSuperlayer()
  }
  
  private func setupReplicator() {
    let instanceCount = Int(bounds.width / (particleSize + minInstancesOffset))
    particle.position = CGPoint(x: particleSize * 0.5, y: bounds.maxY - particleSize * 0.5)
    let offset = (bounds.width - particleSize * CGFloat(instanceCount)) / (CGFloat(instanceCount) - 1)
    
    replicatorLayer = CAReplicatorLayer()
    replicatorLayer?.instanceCount = instanceCount
    replicatorLayer?.instanceTransform = CATransform3DTranslate(CATransform3DIdentity, particleSize + offset, 0, 0)
    replicatorLayer?.addSublayer(particle)
    layer.addSublayer(replicatorLayer!)
  }
}
