//
//  ImageCarouselComponentView.swift
//  TechXplore
//
//  Created by Lika Nozadze on 7/5/24.
//

import SwiftUI

struct ImageCarouselComponentView: View {
    @State private var selectedImageIndex = 0
    var images: [String]

    var body: some View {
        VStack {
            imageTabView
            indicatorHStack
        }
    }

    private var imageTabView: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(0..<images.count, id: \.self) { index in
                imageAtIndex(index)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
     
        .onAppear {
            selectedImageIndex = 0
        }
    }

    private var indicatorHStack: some View {
        HStack {
            Spacer()
            ForEach(0..<images.count, id: \.self) { index in
                Circle()
                    .fill(index == selectedImageIndex ? Color.primary : Color.secondary)
                    .frame(width: 8, height: 8)
            }
            Spacer()
        }
    }

    private func imageAtIndex(_ index: Int) -> some View {
        Image(images[index])
            .resizable()
            .scaledToFit()
            .tag(index)
    }
}
