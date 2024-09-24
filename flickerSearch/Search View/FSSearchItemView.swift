//
//  FSSearchItemView.swift
//  flickerSearch
//
//  Created by Mian on 9/23/24.
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
                        //progess view for loading stage
                    case .empty:
                        ProgressView().frame(width: 80, height: 80)
                    case .success(let image):
                        //show the image
                        image.resizable().scaledToFit().frame(width: 80, height: 80)
                    case .failure(_):
                        //placeholder image for fail case
                        Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 80)
                    @unknown default:
                        EmptyView()
                    }
                    
                }
            } else {
                //if image path doesnt exist, show placeholder image
                Image(systemName: "photo").resizable().scaledToFit().frame(width: 80, height: 80).clipped()
            }
            Spacer()
        }
    }
}

//#Preview {
//    FSSearchItemView()
//}
