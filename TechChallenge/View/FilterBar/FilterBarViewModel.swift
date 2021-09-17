//
//  FilterBarViewModel.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 17/09/2021.
//

import Foundation
import Combine
import SwiftUI

protocol FilterCategory: Identifiable, Equatable {
    var id: ID { get }
    var name: String { get }
    var color: Color { get }
}

class FilterBarViewModel<Item: FilterCategory>: ObservableObject {
    
    // State
    @Binding var selected: Item
    @Published var categories: [Item]
    
    init(categories: [Item], selected: Binding<Item>) {
        self._categories = .init(initialValue: categories)
        self._selected = selected
    }
    
    func test() {
        self.categories = categories.dropLast()
    }
}
