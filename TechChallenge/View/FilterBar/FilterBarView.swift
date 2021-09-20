//
//  FilterBarView.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 17/09/2021.
//

import Foundation
import SwiftUI

struct FilterBarView<T: FilterCategory>: View {
    @ObservedObject var viewModel: FilterBarViewModel<T>
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                Spacer()
                ForEach(viewModel.categories){ category in
                    VStack {
                        Spacer()
                        Button(action: {
                            viewModel.selected = category
                        }, label: {
                            ZStack {
                                Capsule()
                                    .fill(category.color)
                                Text(category.name)
                                    .foregroundColor(Color.white)
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .lineLimit(1)
                                    .fixedSize()
                                    .padding([.leading, .trailing], 12)
                                    .padding([.top, .bottom], 4)
                            }
                        })
                        Spacer()
                    }
                }
                Spacer()
            }.frame(height: 60)
        }
    }
}

#if DEBUG
struct FilterBarView_Previews: PreviewProvider {
    
    static let categories: [TransactionModel.Category] = TransactionModel.Category.allCases
    
    static var filterBarViewModel: FilterBarViewModel<FilterCategoryImpl> {
        
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
    
    static var previews: some View {
        VStack {
            FilterBarView(viewModel: filterBarViewModel)
                .frame(height: 100)
        }
    }
}
#endif
