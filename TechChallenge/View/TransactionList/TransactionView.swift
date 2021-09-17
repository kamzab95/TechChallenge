//
//  TransactionView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

class TransactionViewModel: ObservableObject {
    @Published var transaction: TransactionModel
    @Published var pinned: Bool
    @Published var action : () -> Void = {}
    
    init(transaction: TransactionModel, pinned: Bool) {
        self._transaction = .init(initialValue: transaction)
        self._pinned = .init(initialValue: pinned)
    }
}

struct TransactionView: View {
    @ObservedObject var viewModel: TransactionViewModel
    
    var transaction: TransactionModel {
        viewModel.transaction
    }
    
    var body: some View {
        VStack {
            HStack {
                Text(transaction.category.rawValue)
                    .font(.headline)
                    .foregroundColor(transaction.category.color)
                Spacer()
                Text(viewModel.pinned ? "|" : "O")
            }
            if !viewModel.pinned {
                HStack {
                    transaction.image
                        .resizable()
                        .frame(
                            width: 60.0,
                            height: 60.0,
                            alignment: .top
                        )
                    
                    VStack(alignment: .leading) {
                        Text(transaction.name)
                            .secondary()
                        Text(transaction.accountName)
                            .tertiary()
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(transaction.amount.formatted())")
                            .bold()
                            .secondary()
                        Text(transaction.date.formatted)
                            .tertiary()
                    }
                }
            }
        }
        .padding(8.0)
        .background(Color.accentColor.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8.0))
        .onTapGesture {
            withAnimation {
                viewModel.action()
            }
        }
    }
}

#if DEBUG
struct TransactionView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            TransactionView(viewModel: .init(transaction: ModelData.sampleTransactions[0], pinned: false))
            TransactionView(viewModel: .init(transaction: ModelData.sampleTransactions[1], pinned: false))
            TransactionView(viewModel: .init(transaction: ModelData.sampleTransactions[0], pinned: true))
            TransactionView(viewModel: .init(transaction: ModelData.sampleTransactions[1], pinned: true))
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
