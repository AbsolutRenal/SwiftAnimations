//
//  CircleActivityIndicator.swift
//  Animations
//
//  Created by AbsolutRenal on 31/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class CircleActivityIndicator: UIActivityIndicatorView, Animatable {
  // *********************************************************************
  // MARK: - Constants
  @IBInspectable let strokeWidth: CGFloat = 4.0
  @IBInspectable let strokeColor: UIColor = UIColor.darkGray
  
  // *********************************************************************
  // MARK: - IBOutlets
  
  // *********************************************************************
  // MARK: - Properties
  lazy private var circleShape: CAShapeLayer = {
    let shape = CAShapeLayer()
    let path = CGPath(ellipseIn: self.bounds.insetBy(dx: self.strokeWidth * 0.5,
                                                     dy: self.strokeWidth * 0.5),
                      transform: nil)
    shape.path = path
    shape.fillColor = nil
    shape.strokeColor = self.strokeColor.cgColor
    shape.lineWidth = self.strokeWidth
    return shape
  }()
//  lazy private let animation: CAAnimationGroup = {
//    
//  }()
  
  // *********************************************************************
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init(coder: NSCoder) {
    super.init(coder: coder)
    configure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  
  // *********************************************************************
  // MARK: - UIActivityIndicatorView
  override func startAnimating() {
    super.startAnimating()
  }
  
  override func stopAnimating() {
    super.stopAnimating()
  }
  
  // *********************************************************************
  // MARK: - Private
  private func configure() {
    layer.sublayers?.forEach {
      $0.removeFromSuperlayer()
    }
    
    layer.addSublayer(circleShape)
    layer.backgroundColor = UIColor.clear.cgColor
    layer.masksToBounds = true
  }
}
