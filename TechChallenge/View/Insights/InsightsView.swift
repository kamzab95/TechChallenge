//
//  InsightsView.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 29/7/21.
//

import SwiftUI

struct InsightsView: View {
    let transactions: [TransactionModel] = ModelData.sampleTransactions
    
    @ObservedObject var viewModel: InsightsViewModel
    
    var body: some View {
        List {
            RingView(viewModel: RingViewModel(container: viewModel.container))
                .scaledToFit()
            
            ForEach(viewModel.totalForCategory) { info in
                HStack {
                    Text(info.category.rawValue)
                        .font(.headline)
                        .foregroundColor(info.category.color)
                    Spacer()
                    Text("$\(info.totalSum.formatted())")
                        .bold()
                        .secondary()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Insights")
    }
}

#if DEBUG
struct InsightsView_Previews: PreviewProvider {
    static let container = AppEnvironment.bootstrap().container
    static var previews: some View {
        InsightsView(viewModel: InsightsViewModel(container: container))
            .previewLayout(.sizeThatFits)
    }
}
#endif
