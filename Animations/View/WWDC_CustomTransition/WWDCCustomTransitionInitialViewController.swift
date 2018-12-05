//
//  WWDCCustomTransitionInitialViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 04/12/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class WWDCCustomTransitionInitialViewController: UIViewController {
  // MARK: - Constants
  private enum Constants {
    static let cornerRadius: CGFloat = 12
  }
  
  // MARK: - IBOutlets
  @IBOutlet weak var imageView: UIImageView!
  
  // MARK: - Properties
  private lazy var  tapGesture: UITapGestureRecognizer = {
    return UITapGestureRecognizer(target: self, action: #selector(didTapPhoto))
  }()
  private let customTransitioningDelegate = WWDCTransitioningDelegate()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    imageView.image = UIImage(named: "LandscapePhoto")
    imageView.layer.cornerRadius = Constants.cornerRadius
    imageView.layer.masksToBounds = true
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    imageView.isUserInteractionEnabled = true
    imageView.addGestureRecognizer(tapGesture)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    imageView.isUserInteractionEnabled = false
    imageView.removeGestureRecognizer(tapGesture)
  }
  
  // MARK: - IBActions
  @objc private func didTapPhoto() {
    let controller = UIStoryboard(name: "WWDCCustomTransition", bundle: nil)
      .instantiateViewController(withIdentifier: "WWDCCustomTransitionFinalViewController")
    controller.transitioningDelegate = customTransitioningDelegate
    controller.modalPresentationStyle = .custom
    present(controller, animated: true, completion: nil)
  }
  
  // MARK: - Public
  func getTransitionProperties() -> WWDCTransitionProperties {
    return WWDCTransitionProperties(cornerRadius: imageView.layer.cornerRadius,
                                    frame: view.convert(imageView.frame, to: UIApplication.shared.keyWindow))
  }
}
