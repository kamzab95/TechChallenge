//
//  TransactionsDataStore.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 20/09/2021.
//

import Foundation
import Combine

protocol TransactionsDataStore {
    func loadAll() -> AnyPublisher<[TransactionModel], Never>
}

class TransactionsDataStoreLocal: TransactionsDataStore {
    func loadAll() -> AnyPublisher<[TransactionModel], Never> {
        Just(ModelData.sampleTransactions)
            .eraseToAnyPublisher()
    }
}
