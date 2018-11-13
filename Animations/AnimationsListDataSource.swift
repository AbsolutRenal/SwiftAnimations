//
//  AnimationsListDataSource.swift
//  Animations
//
//  Created by AbsolutRenal on 13/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

struct Animation {
  let name: String
  let storyboardID: String
  let identifier: String?
  
  func viewController() -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
    if let identifier = identifier {
      return storyboard.instantiateViewController(withIdentifier: identifier)
    } else {
      guard let controller = storyboard.instantiateInitialViewController() else {
        fatalError("Unable to instantiate initial viewController in storyboard named \(storyboardID)")
      }
      return controller
    }
  }
}

class AnimationsListDataSource {
//  private let animations
}
