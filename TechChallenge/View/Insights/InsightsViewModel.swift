//
//  InsightsViewModel.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 19/09/2021.
//

import Foundation
import Combine
import SwiftUI

class InsightsViewModel: ObservableObject {
    @Published var totalForCategory: [TransactionCategory]
    
    private var transactionService: TransactionsService {
        container.services.transactionsService
    }
    let container: Container
    
    init(container: Container) {
        self.container = container
        self._totalForCategory = .init(initialValue: [])
        
        reload()
    }
    
    func reload() {
        transactionService.loadTotalForEachCategory(sum: keyBind(\.totalForCategory), includeUnpined: false)
    }
}
