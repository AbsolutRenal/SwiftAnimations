//
//  ConnectionSearchViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 13/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class ConnectionSearchViewController: UIViewController {
  // MARK: - Properties
  @IBOutlet private weak var connectionSearchView: ConnectionSearchView!
  
  // MARK: - LifeCycle
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    connectionSearchView.startAnimation()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    connectionSearchView.stopAnimation()
  }
}
