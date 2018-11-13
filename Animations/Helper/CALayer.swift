//
// Created by AbsolutRenal on 16/10/2017.
//

import Foundation
import QuartzCore

extension CALayer {
  /**
   * Used to disable Implicit Animations as CoreAnimation plays default animations during 0.25s on most properties changes
  */
  func setValueDiscreetly(value: Any, forKeyPath keyPath: String) {
    CATransaction.begin()
    CATransaction.setValue(kCFBooleanTrue,
                           forKey: kCATransactionDisableActions)
    setValue(value, forKeyPath: keyPath)
    CATransaction.commit()
  }
}
