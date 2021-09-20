//
//  TransactionsService.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 17/09/2021.
//

import Foundation
import SwiftUI
import Combine

protocol TransactionsService {
    func loadTransactions(transactions: Binding<[TransactionModel]>, filter: TransactionModel.Category?)
    func loadPinned(ids: Binding<Set<TransactionModel.ID>>)
    func loadTotalSum(sum: Binding<Double>, category: TransactionModel.Category?, includeUnpined: Bool)
    func loadTotalForEachCategory(sum: Binding<[TransactionCategory]>, includeUnpined: Bool)
    func loadTransactionsRatio(ratio: Binding<[TransactionRatio]>, includeUnpined: Bool)
    
    func addUnpinned(id: TransactionModel.ID)
    func removeUnpinned(id: TransactionModel.ID)
}

class TransactionsServiceImpl: TransactionsService {
    
    private let transactionsDataStore: TransactionsDataStore
    private let unpinnedIDsDataStore: UnpinnedIDsDataStore
    
    private let cancelBag = CancelBag()
    
    init(transactionsDataStore: TransactionsDataStore, unpinnedIDsDataStore: UnpinnedIDsDataStore) {
        self.transactionsDataStore = transactionsDataStore
        self.unpinnedIDsDataStore = unpinnedIDsDataStore
    }
    
    // TRANSACTIONS
    func loadTransactions(transactions: Binding<[TransactionModel]>, filter: TransactionModel.Category?) {
        transactionsDataStore.loadAll()
            .sink { items in
                let filtered = TransactionsServiceImpl.filterByCategory(transactions: items, category: filter)
                transactions.wrappedValue =  filtered
            }
            .cancel(with: cancelBag)
    }
    
    // PINNED
    func loadPinned(ids: Binding<Set<TransactionModel.ID>>) {
        unpinnedIDsDataStore.loadAll()
            .sink { items in
                ids.wrappedValue = items
            }
            .cancel(with: cancelBag)
    }
    
    func addUnpinned(id: TransactionModel.ID) {
        unpinnedIDsDataStore.insert(id: id)
    }
    
    func removeUnpinned(id: TransactionModel.ID) {
        unpinnedIDsDataStore.remove(id: id)
    }
    
    // SUM
    func loadTotalSum(sum: Binding<Double>, category: TransactionModel.Category?, includeUnpined: Bool) {
        Publishers.CombineLatest(transactionsDataStore.loadAll(), unpinnedIDsDataStore.loadAll())
            .map({ transactions, unpinned -> Double in
                var transactions = TransactionsServiceImpl.filterByCategory(transactions: transactions, category: category)
                
                if !includeUnpined {
                    transactions = transactions.filter({ !unpinned.contains($0.id) })
                }
                
                let total = transactions.map({ $0.amount}).reduce(0, +)
                return total
            })
            .sink { totalSum in
                sum.wrappedValue = totalSum
            }
            .cancel(with: cancelBag)
    }
    
    func loadTotalForEachCategory(sum: Binding<[TransactionCategory]>, includeUnpined: Bool) {
        observeCategoriesSum(includeUnpined: includeUnpined)
            .sink { totalSum in
                sum.wrappedValue = totalSum
            }
            .cancel(with: cancelBag)
    }
    
    func loadTransactionsRatio(ratio: Binding<[TransactionRatio]>, includeUnpined: Bool) {
        observeCategoriesSum(includeUnpined: includeUnpined)
            .map({ categoriesSum -> [TransactionRatio] in
                let total = categoriesSum.map({ $0.totalSum }).reduce(0, +)
                
                let ratioList: [TransactionRatio] = categoriesSum.map({ categorySum in
                    let ratio = categorySum.totalSum / total
                    return TransactionRatio(category: categorySum.category, ratio: ratio)
                })
                
                return ratioList
            })
            .sink { ratioList in
                ratio.wrappedValue = ratioList
            }
            .cancel(with: cancelBag)
    }
    
    private func observeCategoriesSum(includeUnpined: Bool) -> AnyPublisher<[TransactionCategory], Never> {
        Publishers.CombineLatest(transactionsDataStore.loadAll(), unpinnedIDsDataStore.loadAll())
            .map({ transactions, unpinned -> [TransactionCategory] in
                var transactionsCategorySum = TransactionModel.Category.allCases.reduce(into: [TransactionModel.Category : Double](), { $0[$1] = 0 })
                
                var transactions = transactions
                if !includeUnpined {
                    transactions = transactions.filter({ !unpinned.contains($0.id) })
                }
                
                for transaction in transactions {
                    let currentValue = transactionsCategorySum[transaction.category] ?? 0
                    transactionsCategorySum[transaction.category] = currentValue + transaction.amount
                }
                
                return transactionsCategorySum
                    .map({ TransactionCategory(category: $0.key, totalSum: $0.value) })
                    .sorted(by: { $0.category.index < $1.category.index })
            })
            .eraseToAnyPublisher()
    }
    
    private static func filterByCategory(transactions: [TransactionModel], category: TransactionModel.Category?) -> [TransactionModel] {
        
        guard let category = category else {
            return transactions
        }
        
        return transactions.filter({ transaction in
            return transaction.category == category
        })
    }
}


struct TransactionCategory: Identifiable {
    var id: UUID = UUID()
    var category: TransactionModel.Category
    var totalSum: Double
}
