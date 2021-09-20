//
//  TransactionViewModel.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 20/09/2021.
//

import SwiftUI

class TransactionViewModel: ObservableObject {
    @Published var transaction: TransactionModel
    @Published var unpinned: Bool
    @Published var pinAction: ((Bool) -> Void)?
    
    init(transaction: TransactionModel, unpinned: Bool) {
        self._transaction = .init(initialValue: transaction)
        self._unpinned = .init(initialValue: unpinned)
    }
    
    func togglePin() {
        pinAction?(!unpinned)
    }
}
