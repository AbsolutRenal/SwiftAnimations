//
//  AnimationsListDataSource.swift
//  Animations
//
//  Created by AbsolutRenal on 13/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

struct AnimationsSection {
  let name: String
  let animations: [Animation]
}

struct Animation {
  let name: String
  let storyboardID: String
  let identifier: String?
  
  init(name: String, storyboardID: String, identifier: String? = nil) {
    self.name = name
    self.storyboardID = storyboardID
    self.identifier = identifier
  }
  
  var viewController: UIViewController {
    let storyboard = UIStoryboard(name: storyboardID, bundle: nil)
    if let identifier = identifier {
      return storyboard.instantiateViewController(withIdentifier: identifier)
    } else {
      guard let controller = storyboard.instantiateInitialViewController() else {
        fatalError("Unable to instantiate initial viewController in storyboard named \(storyboardID)")
      }
      return controller
    }
  }
}

class AnimationsListDataSource: NSObject, UITableViewDataSource {
  // MARK: - Properties
  private let animations: [AnimationsSection] = [
    AnimationsSection(name: "Activity Indicators", animations: [
      Animation(name: "Square Replicator Loader", storyboardID: "SquareReplicatorLoader"),
      Animation(name: "Circle ActivityIndicator", storyboardID: "CircleActivityIndicator")
      ]),
    AnimationsSection(name: "Buttons", animations: [
      Animation(name: "Circular Menu", storyboardID: "CircleMenuActions"),
      Animation(name: "Share Button", storyboardID: "ShareButton"),
      Animation(name: "Notify Button", storyboardID: "NotifyButton"),
      ]),
    AnimationsSection(name: "Infinite Loop Animations", animations: [
      Animation(name: "Internet Connection Search", storyboardID: "ConnectionSearch"),
      Animation(name: "Atom like animation", storyboardID: "AtomLike"),
      Animation(name: "Pacman", storyboardID: "Pacman"),
      Animation(name: "Morph Replicator", storyboardID: "MorphReplicator"),
      Animation(name: "Heart Pulse", storyboardID: "HeartPulseReplicator")
      ])
  ]
  
  // MARK: - UITableViewDataSource
  func numberOfSections(in tableView: UITableView) -> Int {
    return animations.count
  }
  
  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return animations[section].name
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return animations[section].animations.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: "AnimationCell") else {
      return UITableViewCell()
    }
    cell.textLabel?.text = animations[indexPath.section].animations[indexPath.row].name
    return cell
  }
  
  // MARK: - Public
  func viewController(forIndexPath indexPath: IndexPath) -> UIViewController {
    return animations[indexPath.section].animations[indexPath.row].viewController
  }
}
