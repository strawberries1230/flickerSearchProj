//
//  FSIntent.swift
//  flickerSearch
//
//  Created by Mian on 9/23/24.
//

import Foundation
//intents should all conform to the protocol
protocol FSIntent {
    //type placeholder
    associatedtype ModelType: FSModel
    var model: ModelType { get }
}
