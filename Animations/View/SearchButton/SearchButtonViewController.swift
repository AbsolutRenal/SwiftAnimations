//
//  SearchButtonViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 19/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

class SearchButtonViewController: UIViewController {
  // MARK: - Properties
  
  // MARK: - IBOutlets
  @IBOutlet private weak var seachButton: SearchButton!
  
  // MARK: - LifeCycle
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    seachButton.toggle(true)
  }
  
  // MARK: - Private
}
