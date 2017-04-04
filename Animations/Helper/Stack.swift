//
//  Stack.swift
//  Animations
//
//  Created by AbsolutRenal on 04/04/2017.
//  Copyright © 2017 AbsolutRenal. All rights reserved.
//

import Foundation

struct Stack<T> {
  // *********************************************************************
  // MARK: - Properties
  private var items = [T]()
  private var index = 0
  
  // *********************************************************************
  // MARK: - Public
  mutating func next() -> T {
    incrementIndex()
    return items[index]
  }
  
  func current() -> T {
    return items[index]
  }
  
  mutating func push(_ item: T) {
    items.append(item)
  }
  
  mutating func pop() {
    items.removeLast()
  }
  
  mutating func removeItem(atIndex index: Int) {
    items.remove(at: index)
  }
  
  
  // *********************************************************************
  // MARK: - Private
  private mutating func incrementIndex() {
    index += 1
    if index == items.count {
      index = 0
    }
  }
  
  // *********************************************************************
  // MARK: - Subscript
  subscript (index: Int) -> T {
    get {
      return items[index]
    }
    set(newValue) {
      items[index] = newValue
    }
  }
}
