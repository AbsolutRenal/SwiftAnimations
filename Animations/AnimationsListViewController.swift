//
//  AnimationsListViewController.swift
//  Animations
//
//  Created by AbsolutRenal on 13/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import Foundation
import UIKit

class AnimationsListViewController: UITableViewController {
  // MARK: - Properties
  private let dataSource = AnimationsListDataSource()
  private let navigationControllerDelegate = CustomNavigationControlerDelegate()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = dataSource
    tableView.delegate = self
    tableView.tableFooterView = .init()
    title = "CoreAnimation samples"
    navigationController?.delegate = navigationControllerDelegate
  }
  
  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let controller = dataSource.viewController(forIndexPath: indexPath)
    navigationController?.pushViewController(controller, animated: true)
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerView = super.tableView(tableView, viewForHeaderInSection: section) else {
      return nil
    }
    headerView.backgroundColor = .orange
    return headerView
  }
}
