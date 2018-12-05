//
//  WWDCTransitioningDelegate.swift
//  Animations
//
//  Created by AbsolutRenal on 05/12/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class WWDCTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  func animationController(forPresented presented: UIViewController,
                           presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return WWDCAnimatedTransitioning(from: source, dismissing: false)
  }
  
  func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return WWDCAnimatedTransitioning(dismissing: true)
  }
}
