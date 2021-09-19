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
    
    private let transactionService: TransactionsService = TransactionsServiceImpl.shared
    
    init() {
        self._transactionsRatio = .init(wrappedValue: [])
        
        self.reload()
    }
    
    func reload() {
        transactionService.loadTrasnactionsRatio(ratio: keyBind(\.transactionsRatio), includeUnpined: false)
    }
}
