//
// Created by AbsolutRenal on 13/10/2017.
// Copyright (c) 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import Dispatch

class CircleMenu: UIView, Animatable {
  // *********************************************************************
  // MARK: - Constants
  private let kDisplayAnimName = "display"
  private let kDisplayAnimDuration = 0.5
  private let kCrossHLineWidthDisplayAnimName = "lineWidthDisplayCrossH"
  private let kCrossStrokeDisplayAnimName = "strokeDisplayCross"
  private let kCrossTransformAnimDuration = 0.66
  private let kCrossDisplayAnimDuration = 0.3
  private let kCrossHDisplayWidth = 20.0
  private let kCrossHDisplayLineWidth: CGFloat = 2.0
  private let kTimingFunctionEaseIn = CAMediaTimingFunction(controlPoints: 0.32,
                                                                0.0,
                                                                0.77,
                                                                0.11)
  private let kTimingFunctionEaseOut = CAMediaTimingFunction(controlPoints: 0.32,
                                                                  0.0,
                                                                 0.39,
                                                                 1.18)
  private let kTimingFunctionEaseInOutBounce = CAMediaTimingFunction(controlPoints: 0.52,
                                                                         0.11,
                                                                         0.4,
                                                                         1.34)

  // *********************************************************************
  // MARK: - IBOutlets

  // *********************************************************************
  // MARK: - Properties
  lazy private var backgroundLayer: CAShapeLayer = {
    let l = CAShapeLayer()
    l.frame = mainButton.bounds
    l.path = self.backgroundLayerPath()
    l.strokeColor = UIColor.white.cgColor
    l.strokeEnd = 0.0
    l.lineWidth = 1.0
    l.lineCap = kCALineCapRound
    l.lineJoin = kCALineJoinRound
    l.fillColor = UIColor(red: 58/255.0, green: 175/255.0, blue: 251/255.0, alpha: 1.0).cgColor
    self.mainButton.layer.addSublayer(l)
    return l
  }()

  lazy private var crossH: CAShapeLayer = {
    let l = CAShapeLayer()
    let path = UIBezierPath()
    path.move(to: CGPoint(x: -kCrossHDisplayWidth, y: 0))
    path.addLine(to: CGPoint(x: kCrossHDisplayWidth, y: 0))
    l.strokeColor = UIColor.white.cgColor
    l.lineCap = kCALineCapRound
    l.lineWidth = kCrossHDisplayLineWidth
    l.strokeStart = 0.5
    l.strokeEnd = 0.5
    l.path = path.cgPath
    l.position = mainButton.bounds.center
    self.mainButton.layer.addSublayer(l)
    return l
  }()

  lazy private var crossV: CAShapeLayer = {
    let l = CAShapeLayer()
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: -kCrossHDisplayWidth))
    path.addLine(to: CGPoint(x: 0, y: kCrossHDisplayWidth))
    l.strokeColor = UIColor.white.cgColor
    l.lineCap = kCALineCapRound
    l.lineWidth = kCrossHDisplayLineWidth
    l.strokeStart = 0.5
    l.strokeEnd = 0.5
    l.path = path.cgPath
    l.position = mainButton.bounds.center
    self.mainButton.layer.addSublayer(l)
    return l
  }()

  lazy private var animationsCompletion: [CAAnimation: (() -> Void)] = {
    return [CAAnimation: (() -> Void)]()
  }()

  lazy private var mainButton: UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()

  lazy private var circlesContainer: UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()

  lazy private var buttonsContainer: UIView = {
    let v = UIView()
    v.translatesAutoresizingMaskIntoConstraints = false
    return v
  }()
  
  private var isOpened: Bool = false
  private var isRunning: Bool = false
  private var isReady: Bool = false
  private var selectedAction: CircleMenuAction? = nil
  private var touchedDown = false
  private var touchedState = false
  
  // *********************************************************************
  // MARK: - IBActions
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    guard isReady else {
      return
    }
    if touchIsInsideMainButton(touches.first) {
      touchedDown = true
      animateToTouchedState()
    }
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesMoved(touches, with: event)
    guard touchedDown else {
      return
    }
    let inside = touchIsInsideMainButton(touches.first)
    if inside && !touchedState {
      animateToTouchedState()
    } else if !inside && touchedState {
      animateToReleasedState()
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    guard touchedDown else {
      return
    }
    if touchedState {
      animateToReleasedState()
      openClose()
    }
    touchedDown = false
  }
  
  private func animateToTouchedState() {
    touchedState = true
    animateTouchDown(true)
  }
  
  private func animateToReleasedState() {
    touchedState = false
    animateTouchDown(false)
  }
  
  private func animateTouchDown(_ down: Bool) {
    func start(_ down: Bool) -> CGFloat {
      return down ? 0.3 : 0.0
    }
    func end(_ down: Bool) -> CGFloat {
      return down ? 0.7 : 1.0
    }
    let destStrokeStart = start(down)
    let destStrokeEnd = end(down)
    let shrinkStartCross = buildKeyFrameAnimation(keyPath: "strokeStart",
                                                   values: [start(!down), destStrokeStart],
                                                   keyTimes: [0.0, 1.0],
                                                   duration: 0.0,
                                                   fillMode: kCAFillModeForwards,
                                                   beginTime: nil,
                                                   delegate: nil,
                                                   timingFunctions: [kTimingFunctionEaseOut])
    let shrinkEndCross = buildKeyFrameAnimation(keyPath: "strokeEnd",
                                                 values: [end(!down), destStrokeEnd],
                                                 keyTimes: [0.0, 1.0],
                                                 duration: 0.0,
                                                 fillMode: kCAFillModeForwards,
                                                 beginTime: nil,
                                                 delegate: nil,
                                                 timingFunctions: [kTimingFunctionEaseOut])
    let crossAnims = buildAnimationGroup(animations: [shrinkStartCross, shrinkEndCross],
                                         duration: 0.34)
    crossAnims.timingFunction = kTimingFunctionEaseOut
    crossH.add(crossAnims, forKey: "transformCross")
    crossV.add(crossAnims, forKey: "transformCross")
    crossH.strokeStart = destStrokeStart
    crossH.strokeEnd = destStrokeEnd
    crossV.strokeStart = destStrokeStart
    crossV.strokeEnd = destStrokeEnd
  }
  
  private func openClose() {
    if !isRunning {
      isRunning = true
      if isOpened {
        displayCircles()
      } else {
        hideCircles()
      }
      displayButtons(display: !isOpened)
      transformCross(open: !isOpened)
      isOpened = !isOpened
    }
  }

  // *********************************************************************
  // MARK: - LifeCycle
  override func layoutSubviews() {
    super.layoutSubviews()
    layer.backgroundColor = UIColor.clear.cgColor
    layoutLayers()
  }

  override func didMoveToSuperview() {
    super.didMoveToSuperview()
    guard superview != nil else {
      return
    }
    setup()
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      self.display()
    }
  }

  // *********************************************************************
  // MARK: - Private
  private func setup() {
    addSubview(buttonsContainer)
    addSubview(circlesContainer)
    addSubview(mainButton)

    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
      mainButton.centerYAnchor.constraint(equalTo: centerYAnchor),
      mainButton.widthAnchor.constraint(equalToConstant: 120),
      mainButton.heightAnchor.constraint(equalToConstant: 120),
      circlesContainer.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor),
      circlesContainer.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor),
      circlesContainer.widthAnchor.constraint(equalTo: mainButton.widthAnchor),
      circlesContainer.heightAnchor.constraint(equalTo: mainButton.heightAnchor),
      buttonsContainer.centerXAnchor.constraint(equalTo: mainButton.centerXAnchor),
      buttonsContainer.centerYAnchor.constraint(equalTo: mainButton.centerYAnchor),
      buttonsContainer.widthAnchor.constraint(equalTo: widthAnchor),
      buttonsContainer.heightAnchor.constraint(equalTo: heightAnchor)
      ])

    layoutIfNeeded()
    instantiateCircles()
    instantiateButtons()
  }

  private func layoutLayers() {
    backgroundLayer.frame = mainButton.bounds
    backgroundLayer.path = backgroundLayerPath()
    crossH.position = mainButton.bounds.center
    crossV.position = mainButton.bounds.center
  }

  private func backgroundLayerPath() -> CGPath {
    let path = CGPath(ellipseIn: mainButton.bounds,
                      transform: nil)
    return path
  }

  private func instantiateCircles() {
    var circle: CALayer
    for _ in 0..<8 {
      circle = CALayer()
      circle.opacity = 0.5
      circle.backgroundColor = UIColor.white.cgColor
      circlesContainer.layer.addSublayer(circle)
    }
  }

  private func instantiateButtons() {
    var button: CircleMenuActionButton?
    let initFrame = CGRect(origin: buttonsContainer.bounds.center, size: CGSize(width: 60, height: 60))
    CircleMenuAction.all().forEach {
      button = CircleMenuActionButton(withType: $0, delegate: self, frame: initFrame)
      button?.center = buttonsContainer.center
      buttonsContainer.addSubview(button!)
    }
  }


  private func display() {
    let displayAnim = buildKeyFrameAnimation(keyPath: "strokeEnd",
                                             values: [0.0, 1.0],
                                             keyTimes: [0.0, 1.0],
                                             duration: kDisplayAnimDuration,
                                             fillMode: kCAFillModeForwards,
                                             beginTime: nil,
                                             delegate: self,
                                             timingFunctions: nil)
    displayAnim.timingFunction = kTimingFunctionEaseOut
    backgroundLayer.add(displayAnim, forKey: kDisplayAnimName)
    animationsCompletion[backgroundLayer.animation(forKey: kDisplayAnimName)!] = {
      self.displayCross()
    }
    backgroundLayer.setValueDiscreetly(value: 1.0,
                                       forKeyPath: "strokeEnd")
  }

  private func displayCross() {
    let crossAnimStrokeStart = buildKeyFrameAnimation(keyPath: "strokeStart",
                                                      values: [0.5, 0.0],
                                                      keyTimes: [0.0, 1.0],
                                                      duration: kCrossDisplayAnimDuration,
                                                      fillMode: kCAFillModeForwards,
                                                      beginTime: nil,
                                                      delegate: nil,
                                                      timingFunctions: nil)
    let crossAnimStrokeEnd = buildKeyFrameAnimation(keyPath: "strokeEnd",
                                                    values: [0.5, 1.0],
                                                    keyTimes: [0.0, 1.0],
                                                    duration: kCrossDisplayAnimDuration - 0.2,
                                                    fillMode: kCAFillModeForwards,
                                                    beginTime: nil,
                                                    delegate: nil,
                                                    timingFunctions: nil)
    let crossAnimationGroup = buildAnimationGroup(animations: [crossAnimStrokeStart, crossAnimStrokeEnd],
                                                  duration: kCrossDisplayAnimDuration,
                                                  fillMode: kCAFillModeBackwards,
                                                  beginTime: CACurrentMediaTime() + 0.1,
                                                  delegate: self)
    crossAnimationGroup.timingFunction = kTimingFunctionEaseOut
    
    crossH.add(crossAnimationGroup,
               forKey: kCrossStrokeDisplayAnimName)
    
    crossH.setValueDiscreetly(value: 0.0,
                              forKeyPath: "strokeStart")
    crossH.setValueDiscreetly(value: 1.0,
                              forKeyPath: "strokeEnd")
    crossV.add(crossAnimationGroup,
               forKey: kCrossStrokeDisplayAnimName)
    
    crossV.setValueDiscreetly(value: 0.0,
                              forKeyPath: "strokeStart")
    crossV.setValueDiscreetly(value: 1.0,
                              forKeyPath: "strokeEnd")
    
    animationsCompletion[crossV.animation(forKey: kCrossStrokeDisplayAnimName)!] = {
      self.displayCircles()
    }
  }
  
  private func displayCircles() {
    guard let sublayers = circlesContainer.layer.sublayers else {
      return
    }
    var i = 0
    let insetSize = circlesContainer.bounds.width * 0.15
    let angle = 2 * CGFloat.pi / CGFloat(sublayers.count)
    var delegate: CAAnimationDelegate?
    let positionZero  = circlesContainer.bounds.center
    sublayers.forEach {
      delegate = i == (sublayers.count - 1)
        ? self
        : nil
      $0.frame = circlesContainer.bounds.insetBy(dx: insetSize, dy: insetSize)
      $0.cornerRadius = $0.bounds.width * 0.5
      let finalPosition = $0.position.applying(CGAffineTransform(translationX: 30 * cos(CGFloat(i) * angle),
                                                                 y: 30 * sin(CGFloat(i) * angle)))
      let anim = buildKeyFrameAnimation(keyPath: "position",
                                        values: [positionZero, finalPosition],
                                        keyTimes: [0.0, 1.0],
                                        duration: 1.0,
                                        fillMode: kCAFillModeForwards,
                                        beginTime: nil,
                                        delegate: delegate,
                                        timingFunctions: nil)
      anim.timingFunction = kTimingFunctionEaseOut
      $0.add(anim, forKey: "displayCircle")
      $0.setValueDiscreetly(value: finalPosition, forKeyPath: "position")
      if delegate != nil {
        animationsCompletion[$0.animation(forKey: "displayCircle")!] = {
          if !self.isReady {
            self.isReady = true
          }
          self.selectedAction = nil
        }
      }
      
      i += 1
    }
  }
  
  private func hideCircles() {
    guard let sublayers = circlesContainer.layer.sublayers else {
      return
    }
    var i = 0
    var delegate: CAAnimationDelegate?
    let positionZero  = circlesContainer.bounds.center
    sublayers.forEach {
      delegate = i == (sublayers.count - 1)
        ? self
        : nil
      let anim = buildKeyFrameAnimation(keyPath: "position",
                                        values: [$0.position, positionZero],
                                        keyTimes: [0.0, 1.0],
                                        duration: 0.5,
                                        fillMode: kCAFillModeForwards,
                                        beginTime: nil,
                                        delegate: delegate,
                                        timingFunctions: nil)
      anim.timingFunction = kTimingFunctionEaseIn
      $0.add(anim, forKey: "hideCircle")
      $0.setValueDiscreetly(value: positionZero, forKeyPath: "position")
      i += 1
    }
  }
  
  private func transformCross(open: Bool) {
    let startAngle = open
      ? 0.0
      : CGFloat.pi * 0.25
    let endAngle = open
      ? CGFloat.pi * 0.25
      : 0.0
    let shrinkStartCross = buildKeyFrameAnimation(keyPath: "strokeStart",
                                                   values: [0.3, 0.3, 0.0],
                                                   keyTimes: [0.0, 0.67, 1.0],
                                                   duration: 0.0,
                                                   fillMode: kCAFillModeForwards,
                                                   beginTime: nil,
                                                   delegate: nil,
                                                   timingFunctions: [CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault), kTimingFunctionEaseOut])
    let shrinkEndCross = buildKeyFrameAnimation(keyPath: "strokeEnd",
                                                 values: [0.7, 0.7, 1.0],
                                                 keyTimes: [0.0, 0.67, 1.0],
                                                 duration: 0.0,
                                                 fillMode: kCAFillModeForwards,
                                                 beginTime: nil,
                                                 delegate: nil,
                                                 timingFunctions: [CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault), kTimingFunctionEaseOut])
    let rotateCross = buildKeyFrameAnimation(keyPath: "transform.rotation.z",
                                              values: [startAngle, endAngle, endAngle],
                                              keyTimes: [0.0, 0.67, 1.0],
                                              duration: 0.0,
                                              fillMode: kCAFillModeForwards,
                                              beginTime: nil,
                                              delegate: nil,
                                              timingFunctions: [kTimingFunctionEaseInOutBounce, CAMediaTimingFunction(name: kCAMediaTimingFunctionDefault)])
    let crossAnims = buildAnimationGroup(animations: [shrinkStartCross, shrinkEndCross, rotateCross],
                                          duration: kCrossTransformAnimDuration)
    crossAnims.delegate = self
    crossAnims.timingFunction = kTimingFunctionEaseOut
    crossH.add(crossAnims, forKey: "transformCross")
    crossH.setValueDiscreetly(value: CATransform3DRotate(CATransform3DIdentity,
                                                         endAngle,
                                                         0.0,
                                                         0.0,
                                                         1.0),
                              forKeyPath: "transform")
    crossV.add(crossAnims, forKey: "transformCross")
    animationsCompletion[crossV.animation(forKey: "transformCross")!] = {
      self.isRunning = false
    }
    crossV.setValueDiscreetly(value: CATransform3DRotate(CATransform3DIdentity,
                                                         endAngle,
                                                         0.0,
                                                         0.0,
                                                         1.0),
                              forKeyPath: "transform")
  }

  private func displayButtons(display: Bool) {
    let p1 = buttonsContainer.layer.position
    var p2: CGPoint?
    var i = 0
    let angle = 2 * CGFloat.pi / CGFloat(buttonsContainer.subviews.count)
    let duration = display
        ? 0.8
        : 0.5

    let buttons = display
        ? buttonsContainer.subviews
        : buttonsContainer.subviews.reversed()
    buttons.forEach {
      p2 = $0.layer.position.applying(CGAffineTransform(translationX: 120 * cos(CGFloat(i) * angle),
                                                  y: 120 * sin(CGFloat(i) * angle)))
      let fillMode = i == 0
          ? kCAFillModeForwards
          : kCAFillModeBackwards
      let end = display
        ? p2!
        : p1
      let animation = buildKeyFrameAnimation(keyPath: "position",
                                             values: [$0.layer.position, end],
                                             keyTimes: [0.0, 1.0],
                                             duration: duration,
                                             fillMode: fillMode,
                                             beginTime: CACurrentMediaTime() + (Double(i) * 0.05),
                                             delegate: nil,
                                             timingFunctions: nil)
      animation.timingFunction = kTimingFunctionEaseInOutBounce
      $0.layer.add(animation, forKey: "displayButton")
      $0.layer.setValueDiscreetly(value: end, forKeyPath: "position")
      i += 1
    }
  }
  
  private func touchIsInsideMainButton(_ touch: UITouch?) -> Bool {
    guard let location = touch?.location(in: mainButton),
      mainButton.bounds.contains(location) else {
        return false
    }
    return true
  }

  // *********************************************************************
  // MARK: - CAAnimationDelegate
  func animationDidStart(_ anim: CAAnimation) {

  }

  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    animationsCompletion[anim]?()
    animationsCompletion.removeValue(forKey: anim)
  }
}

extension CircleMenu: CircleMenuActionDelegate {
  func didTapButton(withType type: CircleMenuAction) {
    selectedAction = type
  }

  func shouldSelectButton() -> Bool {
    return selectedAction == nil
  }

  func didEndTapAnimation() {
    openClose()
  }
}
