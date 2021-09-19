//
//  FloatingSumView.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 17/09/2021.
//

import SwiftUI
import Combine

class FloatingSumViewModel: ObservableObject {
    @Published var category: TransactionModel.Category? = nil
    @Published var totalSpent: Double
    
    private let transactionService: TransactionsService = TransactionsServiceImpl.shared
    
    let cancelBag = CancelBag()
    
    init(category: TransactionModel.Category?) {
        _category = .init(initialValue: category)
        _totalSpent = .init(initialValue: 0)
        
        reload()
    }
    
    func reload() {
        transactionService.loadTotalSum(sum: keyBind(\.totalSpent), category: category, includeUnpined: false)
    }
    
}

struct FloatingSumView: View {
    
    @ObservedObject var viewModel: FloatingSumViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.black, lineWidth: 2)
                .background(Color.white)
            VStack(alignment: .center) {
                Text(viewModel.category?.rawValue ?? "all")
                    .foregroundColor(viewModel.category?.color ?? Color.black)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                HStack {
                    Text("Total spent:")
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("$"+viewModel.totalSpent.formatted())
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
            }.padding(8)
        }
        .frame(height: 70)
        .padding(10)
    }
}

struct FloatingSumView_Previews: PreviewProvider {
    static var previews: some View {
        FloatingSumView(viewModel: FloatingSumViewModel(category: .entertainment))
    }
}


extension Binding {
    init(_ defaultValue: Value) {
        self.init(get: { defaultValue }, set: { _ in })
    }
}
