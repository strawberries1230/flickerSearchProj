//
//  FSSearchView.swift
//  flickerSearch
//
//  Created by Mian on 9/23/24.
//

import SwiftUI

struct FSSearchView: View {
    @StateObject private var container: FSContainer<FSSearchViewModel, FSSearchViewIntent>
    init() {
        let model = FSSearchViewModel()
        //pass network manager singleton to the intent
        let intent = FSSearchViewIntent(model: model, networkManager: FSNetworkManager.shared)
        _container = StateObject(wrappedValue: FSContainer(model: model, intent: intent))
    }
    var body: some View {
        NavigationView {
            VStack {
                List(container.model.items, id: \.self) {
                    item in
                    //navigate to detail page
                    NavigationLink {
                        FSItemDetailView(item: item)
                    } label: {
                        //single item display
                        FSSearchItemView(item: item)
                    }
                }
                .searchable(text: Binding(get: {
                    container.model.keyword
                }, set: { container.intent.updateKeyword($0)
                }), prompt: "Searching images...")
                .onChange(of: container.model.keyword) { (oldValue, newValue) in
                    //search image everytime keyword changes
                    if newValue != "" {
                        container.intent.searchImage()
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
