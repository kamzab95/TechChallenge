//
//  TransactionListView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

struct TransactionListView: View {
    @ObservedObject var viewModel: TransactionListViewModel = TransactionListViewModel()
    
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
                        transactionView(transaction: transaction)
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
    
    func transactionView(transaction: TransactionModel) -> TransactionView {
        let viewModel = TransactionViewModel(
            transaction: transaction,
            pinned: viewModel.pinned.contains(transaction.id))
        
        viewModel.pinAction = { pinned in
            if pinned {
                self.viewModel.pin(id: transaction.id)
            } else {
                self.viewModel.unPin(id: transaction.id)
            }
        }
        
        return TransactionView(viewModel: viewModel)
    }
    
    func floatingView() -> FloatingSumView {
        let floatingViewModel = FloatingSumViewModel(
            category: viewModel.transactionFilter.category.category)

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
