//
//  Coordinator.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 14/1/2567 BE.
//

import Foundation

protocol Coordinator {
    var parent: Coordinator? { get set }
    var child: [Coordinator] { get set }

    func start()
}
