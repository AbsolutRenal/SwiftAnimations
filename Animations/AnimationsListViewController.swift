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
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.dataSource = dataSource
    tableView.delegate = self
    tableView.tableFooterView = .init()
  }
  
  // MARK: - UITableViewDelegate
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    navigationController?.pushViewController(dataSource.viewController(forIndexPath: indexPath), animated: true)
  }
  
  override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard let headerView = super.tableView(tableView, viewForHeaderInSection: section) else {
      return nil
    }
    headerView.backgroundColor = .orange
    return headerView
  }
}
