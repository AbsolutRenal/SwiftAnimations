//
//  SearchButton.swift
//  Animations
//
//  Created by AbsolutRenal on 16/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

@IBDesignable
class SearchButton: UIControl, Animatable {
  // MARK: - Constants
  private enum Constants {
    static let circleRadius: CGFloat = 12
    static let thickness: CGFloat = Constants.circleRadius / 4
    static let innerMaxSize: CGFloat = (Constants.circleRadius - Constants.thickness) * 2
    static let crossBarHeight: CGFloat = (Constants.circleRadius) * 4 / 3 - Constants.thickness
    static let duration: CFTimeInterval = 0.3
    static let easing = CAMediaTimingFunction(controlPoints: 0.6, 0,
                                              0.4, 1)
  }
  
  // MARK: - Properties
  private var color: UIColor = UIColor.blue
  private let overallColor = UIColor.white
  @IBInspectable var dominentColor: UIColor {
    get {
      return color
    }
    set (newValue) {
      color = newValue
      innerLayer?.backgroundColor = color.cgColor
    }
  }
  private var queueRotationTransform: CATransform3D {
    return CATransform3DRotate(CATransform3DIdentity, -.pi * 0.25, 0, 0, 1)
  }
  private var queueTranslatedTransform: CATransform3D {
    return CATransform3DRotate(CATransform3DIdentity, .pi * 0.25, 0, 0, 1)
  }
  private var roundLayer: CALayer?
  private var queueLayer: CALayer?
  private var innerLayer: CALayer?
  
  // MARK: - LifeCycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  override func prepareForInterfaceBuilder() {
    super.prepareForInterfaceBuilder()
    setup()
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupLayers()
  }
  
  // MARK: - Public
  func toggle(_ stateCross: Bool) {
    clearAnimations()
    animateInnerLayer(stateCross)
    animateQueueLayer(stateCross)
  }
  
  // MARK: - Private
  private func setup() {
    removeLayersIfNeeded()
    backgroundColor = .clear
    
    roundLayer = CALayer()
    roundLayer?.borderColor = overallColor.cgColor
    roundLayer?.backgroundColor = roundLayer?.borderColor
    roundLayer?.borderWidth = Constants.thickness
    roundLayer?.bounds = CGRect(x: 0, y: 0,
                                width: Constants.circleRadius * 2, height: Constants.circleRadius * 2)
    roundLayer?.cornerRadius = Constants.circleRadius
    layer.addSublayer(roundLayer!)
    
    innerLayer = setupInnerLayer()
    layer.addSublayer(innerLayer!)
    
    queueLayer = setupQueueLayer()
    layer.addSublayer(queueLayer!)
  }
  
  private func setupQueueLayer() -> CALayer {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0,
                          width: Constants.thickness, height: Constants.crossBarHeight)
    layer.backgroundColor = overallColor.cgColor
    layer.cornerRadius = Constants.thickness * 0.5
    layer.transform = CATransform3DTranslate(queueRotationTransform, 0, Constants.circleRadius + Constants.thickness, 0)
    return layer
  }
  
  private func setupInnerLayer() -> CALayer {
    let layer = CALayer()
    layer.bounds = CGRect(x: 0, y: 0,
                          width: Constants.innerMaxSize, height: Constants.innerMaxSize)
    layer.backgroundColor = color.cgColor
    layer.cornerRadius = Constants.innerMaxSize * 0.5
    layer.transform = queueTranslatedTransform
    return layer
  }
  
  private func removeLayersIfNeeded() {
    layer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }
  }
  
  private func setupLayers() {
    roundLayer?.position = bounds.center
    queueLayer?.position = bounds.center
    innerLayer?.position = bounds.center
  }
  
  private func animateInnerLayer(_ stateCross: Bool) {
    let endWidth: CGFloat = stateCross ? Constants.thickness : Constants.innerMaxSize
    let endHeight: CGFloat = stateCross ? Constants.crossBarHeight : Constants.innerMaxSize
    let innerWidthAnimation = buildKeyFrameAnimation(keyPath: "bounds.size.width",
                                                     values: [innerLayer!.bounds.size.width, endWidth],
                                                     keyTimes: [0, 1],
                                                     timingFunctions: [Constants.easing])
    let innerHeightAnimation = buildKeyFrameAnimation(keyPath: "bounds.size.height",
                                                      values: [innerLayer!.bounds.size.height, endHeight],
                                                      keyTimes: [0, 1],
                                                      timingFunctions: [Constants.easing])
    let radiusHeightAnimation = buildKeyFrameAnimation(keyPath: "cornerRadius",
                                                       values: [innerLayer!.cornerRadius, endWidth * 0.5],
                                                       keyTimes: [0, 1],
                                                       timingFunctions: [Constants.easing])
    let innerAnimation = buildAnimationGroup(animations: [innerWidthAnimation, innerHeightAnimation, radiusHeightAnimation],
                                             duration: Constants.duration)
    innerLayer?.add(innerAnimation, forKey: "bounds.size")
    innerLayer?.setValueDiscreetly(value: endWidth * 0.5, forKeyPath: "cornerRadius")
    innerLayer?.setValueDiscreetly(value: endWidth, forKeyPath: "bounds.size.width")
    innerLayer?.setValueDiscreetly(value: endHeight, forKeyPath: "bounds.size.height")
  }
  
  private func animateQueueLayer(_ stateCross: Bool) {
    let endTransform: CATransform3D = stateCross ? queueRotationTransform : queueTranslatedTransform
    let endColor: CGColor = stateCross ? dominentColor.cgColor : overallColor.cgColor
    let queueTransformAnimation = buildKeyFrameAnimation(keyPath: "transform",
                                                         values: [queueLayer!.transform, endTransform],
                                                         keyTimes: [0, 1],
                                                         timingFunctions: [Constants.easing])
    let colorAnimation = buildKeyFrameAnimation(keyPath: "backgroundColor",
                                                values: [queueLayer!.backgroundColor!, endColor],
                                                keyTimes: [0, 1],
                                                timingFunctions: [Constants.easing])
    let queueAnimation = buildAnimationGroup(animations: [queueTransformAnimation, colorAnimation],
                                             duration: Constants.duration)
    queueLayer?.add(queueAnimation, forKey: "transform")
    queueLayer?.setValueDiscreetly(value: endTransform, forKeyPath: "transform")
    queueLayer?.setValueDiscreetly(value: endColor, forKeyPath: "backgroundColor")
  }
  
  private func clearAnimations() {
    roundLayer?.removeAllAnimations()
    queueLayer?.removeAllAnimations()
    innerLayer?.removeAllAnimations()
  }
}
