//
//  FilterBarTests.swift
//  TechChallengeTests
//
//  Created by Kamil Zaborowski on 17/09/2021.
//

import XCTest
import SwiftUI
@testable import TechChallenge

class FilterBarTests: XCTestCase {

    
    let testData: [TransactionModel] = ModelData.sampleTransactions
    
    var filterBarViewModel: FilterBarViewModel<FilterCategoryImpl> {
        
        let b: Binding<FilterCategoryImpl> = Binding {
            return FilterCategoryImpl(category: nil)
        } set: { _ in
            
        }
        
        let categories = TransactionModel.Category.allCases
            .map({
                FilterCategoryImpl(category: $0)
            })
        
        return FilterBarViewModel<FilterCategoryImpl>(
            categories: categories,
            selected: b)
    }
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
    }

    func testFilter() throws {
        let viewModel = TransactionListViewModel(sourceTransactions: testData)
        for category in TransactionModel.Category.allCases {
            viewModel.transactionFilter.category = FilterCategoryImpl(category: category)
            viewModel.reload()
            
            XCTAssert(viewModel.transactions.allSatisfy({ $0.category == category }))
        }
    }
    
    func testFilter2() throws {
        let viewModel = TransactionListViewModel(sourceTransactions: testData)
        
        XCTAssertEqual(viewModel.transactions.count, testData.count)
    }
    
    func testFilter3() throws {
        let viewModel = TransactionListViewModel(sourceTransactions: testData)
        
        viewModel.transactionFilter.category = FilterCategoryImpl(category: .entertainment)
        viewModel.reload()
        
        viewModel.transactionFilter.category = FilterCategoryImpl(category: nil)
        viewModel.reload()
        
        XCTAssertEqual(viewModel.transactions.count, testData.count)
    }

}
