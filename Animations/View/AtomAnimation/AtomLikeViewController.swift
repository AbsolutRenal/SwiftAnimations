//
// Created by AbsolutRenal on 25/10/2017.
// Copyright (c) 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class AtomLikeViewController: UIViewController {
  // *********************************************************************
  // MARK: - IBOutlets
  @IBOutlet weak var atomView: AtomLikeView!

  // *********************************************************************
  // MARK: - LifeCycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    atomView.display()
  }
}
