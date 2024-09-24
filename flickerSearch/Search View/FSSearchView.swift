//
//  FSSearchView.swift
//  flickerSearch
//
//  Created by V D on 9/23/24.
//

import SwiftUI

struct FSSearchView: View {
    @StateObject private var container: FSContainer<FSSearchViewModel, FSSearchViewIntent>
    init() {
        let model = FSSearchViewModel()
        let intent = FSSearchViewIntent(model: model, networkManager: FSNetworkManager.shared)
        _container = StateObject(wrappedValue: FSContainer(model: model, intent: intent))
    }
    var body: some View {
        NavigationView {
            VStack {
                List(container.model.items, id: \.self) {
                    item in
                    NavigationLink {
                        FSItemDetailView(item: item)
                    } label: {
                        FSSearchItemView(item: item)
                        
                    }
                }
                .searchable(text: Binding(get: {
                    container.model.keyword
                }, set: { container.intent.updateKeyword($0)
                }), prompt: "Searching images...")
                .onChange(of: container.model.keyword) { (oldValue, newValue) in
                    if newValue != "" {
                        container.intent.searchImage()
                        //                        print(container.model.keyword)
                    }
                    else {
                        container.model.items = []
                    }
                }
                
            }
            .navigationTitle("Search")
        }
        
        
    }
}

#Preview {
    FSSearchView()
}
