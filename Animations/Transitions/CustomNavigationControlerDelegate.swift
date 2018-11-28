//
//  CustomNavigationControlerDelegate.swift
//  Animations
//
//  Created by AbsolutRenal on 27/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class CustomNavigationControlerDelegate: NSObject, UINavigationControllerDelegate {
  public func navigationController(_ navigationController: UINavigationController,
                                   animationControllerFor operation: UINavigationController.Operation,
                                   from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    switch operation {
    case .push, .pop: return ZoomAnimatedTransitioning(forOperation: operation)
    case .none: return nil
    }
  }
  
  public func navigationController(_ navigationController: UINavigationController,
                                   interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return nil
  }
}
