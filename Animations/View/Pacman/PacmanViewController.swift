//
//  PacmanViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 13/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class PacmanViewController: UIViewController {
  // MARK: - Constants
  fileprivate let kPacmanLoaderWidth: CGFloat = 100
  fileprivate let kPacmanLoaderHeight: CGFloat = 20
  fileprivate let kVerticalPositionRatio: CGFloat = 0.15
  
  // MARK: - Properties
  lazy fileprivate var pacmanLayer: PacmanLayer = {
    let frame = CGRect(x: (view.layer.bounds.width - kPacmanLoaderWidth) * 0.5,
                       y: view.layer.bounds.height * (1 - kVerticalPositionRatio) - kPacmanLoaderHeight * 0.5,
                       width: kPacmanLoaderWidth,
                       height: kPacmanLoaderHeight)
    let pacman = PacmanLayer(withFrame: frame)
    return pacman
  }()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.layer.addSublayer(pacmanLayer)
  }
}
