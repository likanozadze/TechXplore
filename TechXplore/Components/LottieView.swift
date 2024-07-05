//
//  LottieView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI
import Lottie

struct LottieView: UIViewRepresentable {
    var filename: String
    
    func makeUIView(context: Context) -> some UIView {
        let animationView = LottieAnimationView()
        let animation = LottieAnimation.named(filename)
        animationView.animation = animation
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()
        return animationView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
       
    }
}
