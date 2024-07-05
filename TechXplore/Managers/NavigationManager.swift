//
//  NavigationManager.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import Foundation
import SwiftUI

enum NavigationDestination {
  case loginView
  case registerView
    case mainView
}

class NavigationManager: ObservableObject {
  @Published var currentDestination: NavigationDestination = .loginView
}
