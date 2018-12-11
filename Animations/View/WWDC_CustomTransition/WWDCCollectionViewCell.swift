//
//  WWDCCollectionViewCell.swift
//  Animations
//
//  Created by AbsolutRenal on 11/12/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

final class WWDCCollectionViewCell: UICollectionViewCell {
  // MARK: - IBOutlet
  @IBOutlet private weak var imageView: UIImageView!
  
  // MARK: - LifeCycle
  override func prepareForReuse() {
    super.prepareForReuse()
    imageView.image = nil
  }
  
  // MARK: - Public
  func configure(withImage image: UIImage?, cornerRadius: CGFloat) {
    clipsToBounds = false
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 1)
    layer.shadowRadius = 1
    layer.shadowOpacity = 0.3
    imageView.layer.cornerRadius = cornerRadius
    imageView.layer.masksToBounds = true
    imageView.contentMode = .top
    imageView.image = image
  }
}
