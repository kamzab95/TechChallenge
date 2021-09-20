//
//  UnpinnedIDsDataStore.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 20/09/2021.
//

import Foundation
import Combine

protocol UnpinnedIDsDataStore {
    func loadAll() -> AnyPublisher<Set<TransactionModel.ID>, Never>
    func insert(id: TransactionModel.ID)
    func remove(id: TransactionModel.ID)
}

class UnpinnedIDsDataStoreLocal: UnpinnedIDsDataStore {
    @Published var unpinnedSource = Set<TransactionModel.ID>()
    
    func loadAll() -> AnyPublisher<Set<TransactionModel.ID>, Never> {
        $unpinnedSource.eraseToAnyPublisher()
    }
    
    func insert(id: TransactionModel.ID) {
        unpinnedSource.insert(id)
    }
    
    func remove(id: TransactionModel.ID) {
        unpinnedSource.remove(id)
    }
}
