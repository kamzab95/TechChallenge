//
//  Binding.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 19/09/2021.
//

import Foundation
import SwiftUI

extension Binding where Value: Equatable {
    typealias ValueClosure = (Value) -> Void
    
    func onSet(_ perform: @escaping ValueClosure) -> Self {
        return .init(get: { () -> Value in
            self.wrappedValue
        }, set: { value in
            if self.wrappedValue != value {
                self.wrappedValue = value
            }
            perform(value)
        })
    }
}

extension Binding {
    init(_ defaultValue: Value) {
        self.init(get: { defaultValue }, set: { _ in })
    }
}
