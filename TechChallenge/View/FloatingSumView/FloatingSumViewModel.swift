//
//  FloatingSumViewModel.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 20/09/2021.
//

import SwiftUI
import Combine

class FloatingSumViewModel: ObservableObject {
    @Published var category: TransactionModel.Category? = nil
    @Published var totalSpent: Double
    
    private var transactionService: TransactionsService {
        container.services.transactionsService
    }
    
    private let container: Container
    private let cancelBag = CancelBag()
    
    init(container: Container, category: TransactionModel.Category?) {
        self.container = container
        _category = .init(initialValue: category)
        _totalSpent = .init(initialValue: 0)
        
        reload()
    }
    
    func reload() {
        transactionService.loadTotalSum(sum: keyBind(\.totalSpent), category: category, includeUnpined: false)
    }
    
}

extension TransactionModel.Category: FilterCategory {
    var name: String {
        self.rawValue
    }
}
