//
//  FSSearchViewModel.swift
//  flickerSearch
//
//  Created by Mian on 9/23/24.
//

import Foundation

class FSSearchViewModel: FSModel, ObservableObject {
    @Published var keyword: String = ""
    @Published var items: [ImageInfo] = []
}
