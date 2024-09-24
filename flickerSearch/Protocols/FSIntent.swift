//
//  FSIntent.swift
//  flickerSearch
//
//  Created by V D on 9/23/24.
//

import Foundation

protocol FSIntent {
    associatedtype ModelType: FSModel
    var model: ModelType { get }
}
