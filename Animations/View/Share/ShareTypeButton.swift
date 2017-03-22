//
//  ShareTypeButton.swift
//  Animations
//
//  Created by AbsolutRenal on 22/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class ShareTypeButton: UIButton, Animatable {
  // *********************************************************************
  // MARK: - Properties
  private let appearEasing = CAMediaTimingFunction(controlPoints: 0.52, 0.07, 0.16, 1)
  private let color: UIColor = UIColor(red: 54.0/255.0, green: 191.0/255.0, blue: 166.0/255.0, alpha: 1.0)
  private let backgroundDeselectedColor: UIColor = UIColor.white
  private let backgroundSelectedColor: UIColor = UIColor(red: 168.0/255.0, green: 0.0, blue: 137.0/255.0, alpha: 1.0)
  private var type: ShareType
  private var startFrame: CGRect
  private var endFrame: CGRect
  private let size: CGFloat
  
  // *********************************************************************
  // MARK: - Lifecycle
  required init(withType type: ShareType, startFrame: CGRect, endFrame: CGRect) {
    self.type = type
    self.startFrame = startFrame
    self.endFrame = endFrame
    size = startFrame.size.width
    super.init(frame: startFrame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("Should use init(withType:frame:)")
    return nil
  }

  // *********************************************************************
  // MARK: - Private
  private func configure() {
    layer.cornerRadius = frame.size.height * 0.5
    layer.backgroundColor = backgroundDeselectedColor.cgColor
    
    imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    imageView?.contentMode = .scaleAspectFill
    let image = type.icon().withRenderingMode(.alwaysTemplate)
    imageView?.image = image
    
    tintColor = color
  }
  
  // *********************************************************************
  // MARK: - Public
  func reinit() {
    frame = endFrame
    layer.backgroundColor = backgroundDeselectedColor.cgColor
  }
  
  func display(delay: NSNumber) {
    let display = buildKeyFrameAnimation(keyPath: "position.x",
                                         values: [startFrame.origin.x + size * 0.5, endFrame.origin.x + size * 0.5],
                                         keyTimes: [delay, 1.0],
                                         duration: 0.6,
                                         delegate: nil,
                                         timingFunctions: [appearEasing])
    layer.add(display, forKey: "display")
    layer.frame = endFrame
  }
  
  func hide(delay: NSNumber) {
    
  }
}
