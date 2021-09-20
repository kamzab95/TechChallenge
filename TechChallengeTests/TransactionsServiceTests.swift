//
//  TransactionsServiceTests.swift
//  TechChallengeTests
//
//  Created by Kamil Zaborowski on 20/09/2021.
//

import XCTest
import Combine
import SwiftUI
@testable import TechChallenge

class TransactionsServiceTests: XCTestCase {
    
    
    let transactionsDataStore = TransactionsDataStoreDummy()
    let unpinnedIDsDataStore = UnpinnedIDsDataStoreDummy()
    
    var service: TransactionsService!
    

    override func setUpWithError() throws {
        // This method is called before the invocation of each test method in the class.
        service = TransactionsServiceImpl(transactionsDataStore: transactionsDataStore, unpinnedIDsDataStore: unpinnedIDsDataStore)
    }

    override func tearDownWithError() throws {
        // This method is called after the invocation of each test method in the class.
    }
    
    

    func testTransactionsAll() throws {
        
        let binding = BindingWithPublisher<[TransactionModel]>([])
        
        let expectation = expectation(description: "testTransactionsAll")
        
        let cancelable = binding.publisher
            .sink { result in
                XCTAssert(result.count == ModelData.sampleTransactions.count)
                expectation.fulfill()
            }
        
        service.loadTransactions(transactions: binding.binding, filter: nil)
        
        wait(for: [expectation], timeout: 10)
        cancelable.cancel()
    }
    
    func testTransactionsFiltering() throws {
        for category in TransactionModel.Category.allCases {
            let expectation = expectation(description: "testTransactionsFiltering_\(category.rawValue)")
            
            let binding = BindingWithPublisher<[TransactionModel]>([])
            
            let cancelable = binding.publisher
                .sink { result in
                    print("result \(result.map({ $0.category }))")
                    XCTAssert(result.allSatisfy({ $0.category == category }))
                    expectation.fulfill()
                }
            
            service.loadTransactions(transactions: binding.binding, filter: category)
            
            wait(for: [expectation], timeout: 10)
            cancelable.cancel()
        }
    }
    
    func testTransactionsTotal() throws {
        let expectation = expectation(description: "testTransactionsTotal")
        
        let binding = BindingWithPublisher<Double>(0)
        
        let cancelable = binding.publisher
            .sink { [unowned self] result in
                let expected = self.filteredTransactions(category: nil)
                    .map({ $0.amount })
                    .reduce(0, +)
                
                XCTAssertEqual(expected, result)
                expectation.fulfill()
            }
        
        service.loadTotalSum(sum: binding.binding, category: nil, includeUnpined: false)
        
        wait(for: [expectation], timeout: 10)
        cancelable.cancel()
    }
    
    func testTransactionsFilteredTotal() throws {
        for category in TransactionModel.Category.allCases {
            let expectation = expectation(description: "testTransactionsFilteredTotal_\(category.rawValue)")
            
            let binding = BindingWithPublisher<Double>(0)
            
            let cancelable = binding.publisher
                .sink { [unowned self] result in
                    let expected = self.filteredTransactions(category: category)
                        .map({ $0.amount })
                        .reduce(0, +)
                    
                    XCTAssertEqual(expected, result)
                    expectation.fulfill()
                }
            
            service.loadTotalSum(sum: binding.binding, category: category, includeUnpined: false)
            
            wait(for: [expectation], timeout: 10)
            cancelable.cancel()
        }
    }

    func testTransactionsTotalWithUnpinned() throws {
        
        let unpinnedList = [ModelData.sampleTransactions[0].id, ModelData.sampleTransactions[4].id]
        
        for id in unpinnedList {
            service.addUnpinned(id: id)
        }
        
        let transactions = ModelData.sampleTransactions.filter({ !unpinnedList.contains($0.id) })
        
        let expectation = expectation(description: "testTransactionsTotalWithUnpinned")
        
        let binding = BindingWithPublisher<Double>(0)
        
        let cancelable = binding.publisher
            .sink { [unowned self] result in
                let expected = self.filteredTransactions(transactions: transactions, category: nil)
                    .map({ $0.amount })
                    .reduce(0, +)
                
                XCTAssertEqual(expected, result)
                expectation.fulfill()
            }
        
        service.loadTotalSum(sum: binding.binding, category: nil, includeUnpined: false)
        
        wait(for: [expectation], timeout: 10)
        cancelable.cancel()
    }
    
    func testTransactionsFilteredTotalWithUnpinned() throws {
        
        let unpinnedList = [ModelData.sampleTransactions[0].id, ModelData.sampleTransactions[4].id]
        
        for id in unpinnedList {
            service.addUnpinned(id: id)
        }
        
        let transactions = ModelData.sampleTransactions.filter({ !unpinnedList.contains($0.id) })
        
        for category in TransactionModel.Category.allCases {
            let expectation = expectation(description: "testTransactionsFilteredTotalWithUnpinned_\(category.rawValue)")
            
            let binding = BindingWithPublisher<Double>(0)
            
            let cancelable = binding.publisher
                .sink { [unowned self] result in
                    let expected = self.filteredTransactions(transactions: transactions, category: category)
                        .map({ $0.amount })
                        .reduce(0, +)
                    
                    XCTAssertEqual(expected, result)
                    expectation.fulfill()
                }
            
            service.loadTotalSum(sum: binding.binding, category: category, includeUnpined: false)
            
            wait(for: [expectation], timeout: 10)
            cancelable.cancel()
        }
    }
    
    func testTransactionsTotalWithUnpinnedIncluded() throws {
        
        let unpinnedList = [ModelData.sampleTransactions[0].id, ModelData.sampleTransactions[4].id]
        
        for id in unpinnedList {
            service.addUnpinned(id: id)
        }
        
        let expectation = expectation(description: "testTransactionsTotalWithUnpinnedIncluded")
        
        let binding = BindingWithPublisher<Double>(0)
        
        let cancelable = binding.publisher
            .sink { [unowned self] result in
                let expected = self.filteredTransactions(category: nil)
                    .map({ $0.amount })
                    .reduce(0, +)
                
                XCTAssertEqual(expected, result)
                expectation.fulfill()
            }
        
        service.loadTotalSum(sum: binding.binding, category: nil, includeUnpined: true)
        
        wait(for: [expectation], timeout: 10)
        cancelable.cancel()
    }
    
    func testTransactionsFilteredTotalWithUnpinnedIncluded() throws {
        
        let unpinnedList = [ModelData.sampleTransactions[0].id, ModelData.sampleTransactions[4].id]
        
        for id in unpinnedList {
            service.addUnpinned(id: id)
        }
        
        
        for category in TransactionModel.Category.allCases {
            let expectation = expectation(description: "testTransactionsFilteredTotalWithUnpinnedIncluded\(category.rawValue)")
            
            let binding = BindingWithPublisher<Double>(0)
            
            let cancelable = binding.publisher
                .sink { [unowned self] result in
                    let expected = self.filteredTransactions(category: category)
                        .map({ $0.amount })
                        .reduce(0, +)
                    
                    XCTAssertEqual(expected, result)
                    expectation.fulfill()
                }
            
            service.loadTotalSum(sum: binding.binding, category: category, includeUnpined: true)
            
            wait(for: [expectation], timeout: 10)
            cancelable.cancel()
        }
    }
    
    func testTransactionsUnpinned(){
        
        let unpinnedList = Set([ModelData.sampleTransactions[2].id, ModelData.sampleTransactions[6].id])
        
        for id in unpinnedList {
            service.addUnpinned(id: id)
        }
        
        let binding = BindingWithPublisher<Set<TransactionModel.ID>>(Set())
        
        let expectation = expectation(description: "testTransactionsUnpinned")
        
        let cancelable = binding.publisher
            .sink { [unowned self] result in
                XCTAssertEqual(result, unpinnedList)
                expectation.fulfill()
            }
        
        service.loadPinned(ids: binding.binding)
        
        wait(for: [expectation], timeout: 10)
        cancelable.cancel()
    }
    
    private func filteredTransactions(category: TransactionModel.Category?) -> [TransactionModel] {
        filteredTransactions(transactions: ModelData.sampleTransactions, category: category)
    }
    
    private func filteredTransactions(transactions: [TransactionModel], category: TransactionModel.Category?) -> [TransactionModel] {
        guard let category = category else {
            return transactions
        }
        return transactions.filter({ $0.category == category })
    }
}

class TransactionsDataStoreDummy: TransactionsDataStore {
    func loadAll() -> AnyPublisher<[TransactionModel], Never> {
        Just(ModelData.sampleTransactions)
            .eraseToAnyPublisher()
    }
}

class UnpinnedIDsDataStoreDummy: UnpinnedIDsDataStore {
    @Published var unpinnedSource = Set<TransactionModel.ID>()
    
    func loadAll() -> AnyPublisher<Set<TransactionModel.ID>, Never> {
        $unpinnedSource
            .eraseToAnyPublisher()
    }
    
    func insert(id: TransactionModel.ID) {
        unpinnedSource.insert(id)
    }
    
    func remove(id: TransactionModel.ID) {
        unpinnedSource.remove(id)
    }
}

struct BindingWithPublisher<Value> {
    
    let binding: Binding<Value>
    var publisher: PassthroughSubject<Value, Never>
    
    init(_ value: Value) {
        var value = value
        let publisher = PassthroughSubject<Value, Never>()
        binding = Binding<Value>(
            get: { value },
            set: {
                value = $0
                publisher.send($0)
            })
        
        self.publisher = publisher
    }
}
