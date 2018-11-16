//
//  InfiniteSpinnerView.swift
//  Animations
//
//  Created by AbsolutRenal on 16/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

class InfiniteSpinnerView: UIView {
  // MARK: - Properties
  private var leftLayer: CAShapeLayer?
  private var rightLayer: CAShapeLayer?
  
  // MARK: - LifeCycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    removeLayersIfNeeded()
    setupLayers()
  }
  
  // MARK: - Private
  private func setup() {
    backgroundColor = .clear
  }
  
  private func removeLayersIfNeeded() {
    leftLayer?.removeAllAnimations()
    leftLayer?.removeFromSuperlayer()
    rightLayer?.removeAllAnimations()
    rightLayer?.removeFromSuperlayer()
  }
  
  private func setupLayers() {
    leftLayer = circleLayer(at: bounds.width * 0.25, clockwise: false)
    layer.addSublayer(leftLayer!)
    rightLayer = circleLayer(at: bounds.width * 0.75, clockwise: true)
    layer.addSublayer(rightLayer!)
  }
  
  private func circleLayer(at x: CGFloat, clockwise: Bool) -> CAShapeLayer {
    let layer = CAShapeLayer()
    layer.path = bezierPath(centered: CGPoint(x: x, y: bounds.midY), clockwise: clockwise)
    layer.strokeColor = UIColor.white.cgColor
    layer.lineWidth = 16
    layer.lineCap = kCALineCapRound
    layer.fillColor = UIColor.clear.cgColor
    return layer
  }
  
  private func bezierPath(centered position: CGPoint, clockwise: Bool) -> CGPath {
    let startAngle: CGFloat = clockwise ? -.pi : 0
    let endAngle: CGFloat = clockwise ? .pi : 2 * .pi
    let path = UIBezierPath(arcCenter: position,
                            radius: bounds.height * 0.5,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: clockwise)
    return path.cgPath
  }
}
