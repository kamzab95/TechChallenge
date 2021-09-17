//
//  TransactionListViewModel.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 17/09/2021.
//

import Foundation
import SwiftUI

struct TransactionFilter {
    var category: FilterCategoryImpl = FilterCategoryImpl(category: nil)
}

struct FilterCategoryImpl: FilterCategory {
    let id: UUID = UUID()
    
    var name: String {
        category?.name ?? "all"
    }
    
    var color: Color {
        category?.color ?? .black
    }
    
    var category: TransactionModel.Category?
}

class TransactionListViewModel: ObservableObject {
    
    @Published var transactions: [TransactionModel]
    @Published var transactionFilter: TransactionFilter = TransactionFilter()
    @Published var pinned: Set<TransactionModel.ID> = Set()
    
    private let sourceTransactions: [TransactionModel]
    
    init(sourceTransactions: [TransactionModel]) {
        self.sourceTransactions = sourceTransactions
        self._transactions = .init(initialValue: sourceTransactions)
    }
    
    func reload() {
        var transactions = self.sourceTransactions
        if let categoryFilter = transactionFilter.category.category {
            transactions = transactions.filter({ $0.category == categoryFilter })
        }
        
        self.transactions = transactions
    }
}
