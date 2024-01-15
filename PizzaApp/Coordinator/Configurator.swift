//
//  Configurator.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 14/1/2567 BE.
//

import Foundation
import UIKit

class Configurator {
    static func configure(viewController: UIViewController) {
        if let controller = viewController as? ViewController {
            let presenter = ViewPresenter(controller: controller)
            let interactor = ViewInteractor(presenter: presenter)
            controller.interactor = interactor
        }
    }
}
