//
//  JsonDecoder.swift
//  flickerSearch
//
//  Created by V D on 9/23/24.
//

import Foundation

func jsonDecoder<T: Decodable>(data: Data) -> T? {
    let decoder = JSONDecoder()
    do {
        let data = try decoder.decode(T.self, from: data)
        return data
    } catch {
        return nil
    }
}
