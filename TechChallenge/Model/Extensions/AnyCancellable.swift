//
//  AnyCancellable.swift
//  TechChallenge
//
//  Created by Kamil Zaborowski on 18/09/2021.
//

import Foundation
import Combine

extension AnyCancellable {
    func cancel(with cancelBag: CancelBag) {
        cancelBag.insert(self)
    }
}
