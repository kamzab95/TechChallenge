//
//  TechChallengeApp.swift
//  TechChallenge
//
//  Created by Adrian Tineo Cabello on 27/7/21.
//

import SwiftUI

@main
struct TechChallengeApp: App {
    
    let environment = AppEnvironment.bootstrap()

    var body: some Scene {
        WindowGroup {
            TabView {
                NavigationView {
                    TransactionListView(viewModel: TransactionListViewModel(container: environment.container))
                }
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet")
                }
                
                NavigationView {
                    InsightsView(viewModel: InsightsViewModel(container: environment.container))
                }
                .tabItem {
                    Label("Insights", systemImage: "chart.pie.fill")
                }
            }
        }
    }
}
