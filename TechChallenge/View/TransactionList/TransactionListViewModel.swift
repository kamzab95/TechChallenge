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
    @Published private(set) var pinned: Set<TransactionModel.ID> = Set()
    
    private let transactionService: TransactionsService = TransactionsServiceImpl.shared
    
    init() {
        self._transactions = .init(initialValue: [])
        
        reload()
    }
    
    func reload() {
        transactionService.loadTransactions(transactions: keyBind(\.transactions), filter: transactionFilter.category.category)
        transactionService.loadPinned(ids: keyBind(\.pinned))
    }
    
    func pin(id: TransactionModel.ID) {
        transactionService.addUnpinned(id: id)
    }
    
    func unPin(id: TransactionModel.ID) {
        transactionService.removeUnpinned(id: id)
    }
}
