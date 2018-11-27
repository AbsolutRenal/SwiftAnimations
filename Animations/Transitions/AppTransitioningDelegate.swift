//
//  AppTransitioningDelegate.swift
//  Animations
//
//  Created by AbsolutRenal on 26/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class AppTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
  public func animationController(forPresented presented: UIViewController,
                                  presenting: UIViewController,
                                  source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ZoomInAnimatedTransitioning()
  }
  
  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return ZoomOutAnimatedTransitioning()
  }
}
