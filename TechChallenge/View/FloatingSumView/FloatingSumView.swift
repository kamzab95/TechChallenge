//
//  FloatingSumView.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 17/09/2021.
//

import SwiftUI
import Combine

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

#if DEBUG
struct FloatingSumView_Previews: PreviewProvider {
    static let container = AppEnvironment.bootstrap().container
    static var previews: some View {
        FloatingSumView(viewModel: FloatingSumViewModel(container: container, category: .entertainment))
    }
}
#endif
