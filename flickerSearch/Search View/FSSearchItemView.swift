//
//  FSSearchItemView.swift
//  flickerSearch
//
//  Created by V D on 9/23/24.
//

import SwiftUI

struct FSSearchItemView: View {
    let item: ImageInfo
    var body: some View {
        HStack {
            Spacer()
            if let imagePath = item.media?.imagePath, let url = URL(string: imagePath) {
                AsyncImage(url: url) {
                    phase in
                    switch phase {
                    case .empty:
                        ProgressView().frame(width: 80, height: 80)
                    case .success(let image):
                        image.resizable().scaledToFit().frame(width: 80, height: 80)
                    case .failure(_):
                        Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 80)
                    @unknown default:
                        EmptyView()
                    }
                    
                }
            } else {
                Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 80).clipped()
            }
            Spacer()
        }
    }
}

//#Preview {
//    FSSearchItemView()
//}
