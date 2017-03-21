//
//  ShareButton.swift
//  Animations
//
//  Created by AbsolutRenal on 17/03/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit


protocol ShareButtonDelegate: class {
  
}

enum ShareType {
  case Facebook
  case Twitter
  case LinkedIn
  case Viadeo
  case Mail
  
  func imageName() -> UIImage {
    let image: UIImage
    switch self {
    case .Facebook:
      image = #imageLiteral(resourceName: "fb_icon")
    case .Twitter:
      image = #imageLiteral(resourceName: "twitter_icon")
    case .LinkedIn:
      image = #imageLiteral(resourceName: "linkedIn_icon")
    case .Viadeo:
      image = #imageLiteral(resourceName: "viadeo_icon")
    case .Mail:
      image = #imageLiteral(resourceName: "mail_icon")
    }
    return image
  }
  
  static func all() -> [ShareType] {
    return [.Facebook, .Twitter, .LinkedIn, .Viadeo, .Mail]
  }
}

class ShareButton: UIView, Animatable {
  // *********************************************************************
  // MARK: - Constants
  private let shareLabel = "Share"
  private let openningEase = CAMediaTimingFunction(controlPoints: 0.8, 0, 0.7, 1)
  
  // *********************************************************************
  // MARK: - IBOutlet
  @IBOutlet weak var whiteButton: UIButton! {
    didSet {
      whiteButton.titleLabel?.font = UIFont.systemFont(ofSize: 17.0, weight: UIFontWeightThin)
      whiteButton.setTitle(shareLabel, for: .normal)
      whiteButton.setTitleColor(UIColor(red: 193.0/255.0, green: 193.0/255.0, blue: 193.0/255.0, alpha: 1.0), for: .normal)
      whiteButton.layer.cornerRadius = whiteButton.layer.bounds.height * 0.5
    }
  }
  
  // *********************************************************************
  // MARK: - Properties
  weak var delegate: ShareButtonDelegate?
  
  private var shareItems: [ShareType] {
    get {
      if let itemsToDisplay = items, itemsToDisplay.count > 0 {
        return itemsToDisplay
      } else {
        return ShareType.all()
      }
    }
  }
  var items: [ShareType]?
  
  // *********************************************************************
  // MARK: - Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    configure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    configure()
  }
  
  // *********************************************************************
  // MARK: - Private func
  private func configure() {
    layer.cornerRadius = layer.bounds.height * 0.5
  }
  
  private func openBox() {
    whiteButton.layer.anchorPoint = CGPoint(x: 0.5, y: 0)
    whiteButton.layer.position = CGPoint(x: whiteButton.layer.position.x,
                                         y: 0)
    let open = buildKeyFrameAnimation(keyPath: "transform.rotation.x",
                                      values: [0.0, M_PI_2],
                                      keyTimes: [0.0, 1.0],
                                      duration: 0.5,
                                      delegate: self,
                                      timingFunctions: [openningEase])
    whiteButton.layer.add(open, forKey: "open")
    whiteButton.layer.transform = CATransform3DRotate(CATransform3DIdentity, CGFloat(M_PI_2), 1.0, 0.0, 0.0)
  }
  
  // *********************************************************************
  // MARK: - IBAction
  @IBAction func whiteButtonDidTap(_ sender: UIButton) {
    openBox()
  }
}
