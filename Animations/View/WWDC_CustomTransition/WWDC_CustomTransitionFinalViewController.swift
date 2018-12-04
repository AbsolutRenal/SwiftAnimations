//
//  WWDC_CustomTransitionFinalViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 04/12/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class WWDC_CustomTransitionFinalViewController: UIViewController {
  // MARK: - IBOutlets
  @IBOutlet private weak var imageView: UIImageView!
  
  // MARK: - Properties
  private lazy var  tapGesture: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
  }()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    imageView.image = UIImage(named: "LandscapePhoto")
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGesture)
    imageView.layer.masksToBounds = true
  }
  
  // MARK: - IBActions
  @objc private func didTapPhoto() {
    dismiss(animated: true, completion: nil)
  }
}
