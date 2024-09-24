//
//  FSContainer.swift
//  flickerSearch
//
//  Created by V D on 9/23/24.
//

import Foundation
import Combine

class FSContainer<M: FSModel & ObservableObject, I: FSIntent>: ObservableObject where I.ModelType == M {
    let model: M
    let intent: I
    private var cancellables: Set<AnyCancellable> = []
    init(model: M, intent: I) {
        self.model = model
        self.intent = intent
        model.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
