//
//  CancelBag.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 18/09/2021.
//

import Foundation
import Combine

class CancelBag {
    private var cancelables = Set<AnyCancellable>()
    
    deinit {
        cancelables.forEach({ $0.cancel() })
    }
    
    func insert(_ cancelable: AnyCancellable) {
        cancelables.insert(cancelable)
    }
}
