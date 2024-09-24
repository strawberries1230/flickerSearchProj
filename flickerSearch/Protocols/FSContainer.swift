//
//  FSContainer.swift
//  flickerSearch
//
//  Created by Mian on 9/23/24.
//

import Foundation
import Combine
//ensure that model type in intent is the same as the type of actual related odel
class FSContainer<M: FSModel & ObservableObject, I: FSIntent>: ObservableObject where I.ModelType == M {
    let model: M
    let intent: I
    private var cancellables: Set<AnyCancellable> = []
    init(model: M, intent: I) {
        self.model = model
        self.intent = intent
        //change in model will trigger the change of container
        model.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
