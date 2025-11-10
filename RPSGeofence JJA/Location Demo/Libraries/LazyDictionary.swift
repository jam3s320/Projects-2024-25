//
//  LazyDictionary.swift
//  Test
//
//  Created by Larry Liu on 2/22/24.
//

import Foundation

struct LazyDictionary<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]
    private var valueFactory: (Key) -> Value

    init(valueFactory: @escaping (Key) -> Value) {
        self.valueFactory = valueFactory
    }

    subscript(key: Key) -> Value {
        mutating get {
            return storage[key] ?? {
                let value = valueFactory(key)
                storage[key] = value
                return value
            }()
        }
    }
}
