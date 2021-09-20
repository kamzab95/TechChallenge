//
//  AppEnvironment.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 20/09/2021.
//

import Foundation

struct AppEnvironment {
    let container: Container
}

extension AppEnvironment {
    static func bootstrap() -> AppEnvironment {
        let transactionsDataStore: TransactionsDataStore = TransactionsDataStoreLocal()
        let unpinnedIDsDataStore: UnpinnedIDsDataStore = UnpinnedIDsDataStoreLocal()
        
        let transactionsService = TransactionsServiceImpl(transactionsDataStore: transactionsDataStore, unpinnedIDsDataStore: unpinnedIDsDataStore)
        
        let services = Container.Services(transactionsService: transactionsService)
        
        let container = Container(services: services)
        return AppEnvironment(container: container)
    }
}
