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
  // MARK: - Properties
  
  // MARK: - LifeCycle
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - Private
  private func setup() {
    backgroundColor = .red
  }
}
