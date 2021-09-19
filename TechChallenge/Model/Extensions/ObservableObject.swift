//
//  ObservableObject.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 18/09/2021.
//

import Foundation
import SwiftUI

extension ObservableObject {
    func keyBind<Value>(_ keyPath: WritableKeyPath<Self, Value>) -> Binding<Value> {
        let defaultValue = self[keyPath: keyPath]
        let binding: Binding<Value> = Binding { [weak self] in
            self?[keyPath: keyPath] ?? defaultValue
        } set: { [weak self] newValue in
            self?[keyPath: keyPath] = newValue
        }
        return binding
    }
}
