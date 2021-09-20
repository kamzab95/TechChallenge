//
//  RingViewModel.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 19/09/2021.
//

import Foundation
import SwiftUI

struct TransactionRatio: Identifiable {
    let id: UUID = UUID()
    var category: TransactionModel.Category
    var ratio: Double
}

class RingViewModel: ObservableObject {
    
    @Published var transactionsRatio: [TransactionRatio]
    
    private var transactionService: TransactionsService {
        container.services.transactionsService
    }
    
    let container: Container
    
    init(container: Container) {
        self.container = container
        self._transactionsRatio = .init(wrappedValue: [])
        
        self.reload()
    }
    
    func reload() {
        transactionService.loadTransactionsRatio(ratio: keyBind(\.transactionsRatio), includeUnpined: false)
    }
}
