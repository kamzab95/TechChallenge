//
//  TransactionListView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

struct TransactionListView: View {
    @ObservedObject var viewModel: TransactionListViewModel = TransactionListViewModel(sourceTransactions: ModelData.sampleTransactions)
    
    var filterBarViewModel: FilterBarViewModel<FilterCategoryImpl> {
        let selected: Binding<FilterCategoryImpl> = $viewModel.transactionFilter.category.onSet({ _ in
            viewModel.reload()
        })
        
        let defaultCategories = TransactionModel.Category.allCases
            .map({
                FilterCategoryImpl(category: $0)
            })
        let allCategory = FilterCategoryImpl(category: nil)
        
        let categories = [allCategory] + defaultCategories
        
        return FilterBarViewModel<FilterCategoryImpl>(
            categories: categories,
            selected: selected)
    }
    
    var body: some View {
        ZStack {
            VStack {
                FilterBarView(viewModel: filterBarViewModel)
                    .frame(height: 48)
                    .background(Color.accentColor.opacity(0.8))
                List {
                    ForEach(viewModel.transactions) { transaction in
                        TransactionView(transaction: transaction)
                    }
                    Spacer()
                        .frame(height: 80)
                }
                .animation(.easeIn)
                .listStyle(PlainListStyle())
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("Transactions")
            }
            VStack {
                Spacer()
                floatingView()
            }
        }
    }
    
    func floatingView() -> FloatingSumView {
        let totalSpent: Double = self.viewModel.transactions
            .map({ $0.amount})
            .reduce(0, +)
        
        let floatingViewModel = FloatingSumViewModel(
            category: viewModel.transactionFilter.category.category,
            totalSpent: totalSpent)
        
        return FloatingSumView(viewModel: floatingViewModel)
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
