//
//  SearchField.swift
//  Animations
//
//  Created by AbsolutRenal on 19/11/2018.
//  Copyright © 2018 AbsolutRenal. All rights reserved.
//

import UIKit

class SearchField: UIView {
  // MARK: - Properties
  var placeHolder: String = "Search" {
    didSet {
      textInput.placeholder = placeHolder
    }
  }
  private var textInput = UITextField()
  private var searchButton = SearchButton()
  
  // MARK: - LifeCycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: - IBActions
  @IBAction private func didTapClear() {
    textInput.text = ""
    searchButton.toggle(false)
  }
  
  // MARK: - Private
  private func setup() {
    setupUI()
    setupConstraints()
    searchButton.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
  }
  
  private func setupUI() {
    backgroundColor = .clear
    textInput = UITextField()
    textInput.font = UIFont.systemFont(ofSize: 14)
    textInput.textColor = .white
    textInput.placeholder = placeHolder
    addSubview(textInput)
    textInput.delegate = self
    
    searchButton.dominentColor = UIColor(fullRed: 52, fullGreen: 60, fullBlue: 72, alpha: 1)
    addSubview(searchButton)
    
    layer.borderColor = UIColor.white.cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 6
  }
  
  private func setupConstraints() {
    translatesAutoresizingMaskIntoConstraints = false
    textInput.translatesAutoresizingMaskIntoConstraints = false
    searchButton.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      textInput.topAnchor.constraint(equalTo: topAnchor),
      textInput.bottomAnchor.constraint(equalTo: bottomAnchor),
      textInput.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      textInput.trailingAnchor.constraint(equalTo: searchButton.leadingAnchor, constant: 0),
      searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4),
      searchButton.topAnchor.constraint(equalTo: topAnchor),
      searchButton.widthAnchor.constraint(equalTo: searchButton.heightAnchor),
      searchButton.centerYAnchor.constraint(equalTo: centerYAnchor)
      ])
  }
}

extension SearchField: UITextFieldDelegate {
  public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    guard let text = textField.text else {
      return false
    }
    let resultingString = (text as NSString).replacingCharacters(in: range, with: string)
    if resultingString.count == 0 {
      searchButton.toggle(false)
    } else {
      searchButton.toggle(true)
    }
    return true
  }
}
