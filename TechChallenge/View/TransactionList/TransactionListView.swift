//
//  TransactionListView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

struct TransactionFilter {
    var category: FilterCategoryImpl = FilterCategoryImpl(category: nil)
}

struct FilterCategoryImpl: FilterCategory {
    let id: UUID = UUID()
    
    var name: String {
        category?.name ?? "all"
    }
    
    var color: Color {
        category?.color ?? .black
    }
    
    var category: TransactionModel.Category?
}

class TransactionListViewModel: ObservableObject {
    
    @Published var transactions: [TransactionModel]
    @Published var transactionFilter: TransactionFilter = TransactionFilter()
    
    private let sourceTransactions: [TransactionModel]
    
    init(sourceTransactions: [TransactionModel]) {
        self.sourceTransactions = sourceTransactions
        self._transactions = .init(initialValue: sourceTransactions)
    }
    
    func reload() {
        var transactions = self.sourceTransactions
        if let categoryFilter = transactionFilter.category.category {
            transactions = transactions.filter({ $0.category == categoryFilter })
        }
        
        self.transactions = transactions
    }
    
}

struct TransactionListView: View {
    @ObservedObject var viewModel: TransactionListViewModel = TransactionListViewModel(sourceTransactions: ModelData.sampleTransactions)
    
    var filterBarViewModel: FilterBarViewModel<FilterCategoryImpl> {
        let selected: Binding<FilterCategoryImpl> = $viewModel.transactionFilter.category.onSet({ _ in
            viewModel.reload()
        })
        
        let categories = TransactionModel.Category.allCases
            .map({
                FilterCategoryImpl(category: $0)
            })
        
        return FilterBarViewModel<FilterCategoryImpl>(
            categories: categories,
            selected: selected)
    }
    
    var body: some View {
        VStack {
            FilterBarView(viewModel: filterBarViewModel)
                .frame(height: 60)
                .background(Color.accentColor.opacity(0.8))
            List {
                ForEach(viewModel.transactions) { transaction in
                    TransactionView(transaction: transaction)
                }
            }
            .animation(.easeIn)
            .listStyle(PlainListStyle())
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Transactions")
        }
    }
}

#if DEBUG
struct TransactionListView_Previews: PreviewProvider {
    static var previews: some View {
        TransactionListView()
    }
}
#endif

extension Binding where Value: Equatable {
    typealias ValueClosure = (Value) -> Void
    
    func onSet(_ perform: @escaping ValueClosure) -> Self {
        return .init(get: { () -> Value in
            self.wrappedValue
        }, set: { value in
            if self.wrappedValue != value {
                self.wrappedValue = value
            }
            perform(value)
        })
    }
}
