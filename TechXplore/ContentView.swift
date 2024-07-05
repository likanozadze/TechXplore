//
//  ContentView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var navigationManager = NavigationManager()

    var body: some View {
        NavigationView {
            switch navigationManager.currentDestination {
            case .loginView:
                LoginView()
                    .environmentObject(navigationManager)
            case .registerView:
                RegisterView()
                    .environmentObject(navigationManager)
            case .mainView:
                RegisterView()
                    .environmentObject(navigationManager)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
