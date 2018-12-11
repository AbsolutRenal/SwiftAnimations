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
    static let aspectRatio: CGFloat = 16/10
    static let inset: CGFloat = 12
    static let lineSpacing: CGFloat = 20
  }
  
  // MARK: - IBOutlets
  @IBOutlet private weak var collectionView: UICollectionView!
  
  // MARK: - Properties
  private var selectedCell: WWDCCollectionViewCell?
  private let images = ["image0",
                        "image1",
                        "image2",
                        "image3",
                        "image4",
                        "image5",
                        "image6",
                        "image7",
                        "image8",
                        "image9"]
  private let customTransitioningDelegate = WWDCTransitioningDelegate()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView.dataSource = self
    collectionView.delegate = self
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
    return WWDCTransitionProperties(cornerRadius: Constants.cornerRadius,
                                    frame: view.convert(selectedCell?.frame ?? .zero, to: UIApplication.shared.keyWindow))
  }
}

extension WWDCCustomTransitionInitialViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wwdcCell", for: indexPath) as? WWDCCollectionViewCell else {
      return UICollectionViewCell()
    }
    cell.configure(withImage: UIImage(named: images[indexPath.row]), cornerRadius: Constants.cornerRadius)
    return cell
  }
  
  // MARK: - UICollectionViewDelegateFlowLayout
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = view.bounds.width - (Constants.inset * 2)
    return CGSize(width: width, height: width / Constants.aspectRatio)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return Constants.lineSpacing
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    return UIEdgeInsets(top: Constants.inset, left: Constants.inset, bottom: Constants.inset, right: Constants.inset)
  }
  
  // MARK: - UICollectionViewDataSource
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return images.count
  }
}
