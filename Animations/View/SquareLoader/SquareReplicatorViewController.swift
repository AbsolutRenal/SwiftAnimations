//
// Created by AbsolutRenal on 25/10/2017.
// Copyright (c) 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class SquareReplicatorViewController: UIViewController {
  // *********************************************************************
  // MARK: - IBOutlets
  @IBOutlet weak var loaderView: SquareReplicatorLoaderView!

  // *********************************************************************
  // MARK: - LifeCycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    loaderView.startLoading()
  }

  override func viewDidDisappear(_ animated: Bool) {
    loaderView.stopLoading()
    super.viewDidDisappear(animated)
  }
}
