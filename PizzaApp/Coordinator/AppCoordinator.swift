//
//  AppCoordinator.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 14/1/2567 BE.
//

import Foundation
import UIKit

class AppCoordinator: Coordinator {
    var parent: Coordinator? = nil
    var child: [Coordinator] = []
    var uiWindow: UIWindow? = nil

    private let navController: UINavigationController

    init(controller: UINavigationController = UINavigationController()) {
        navController = controller
    }

    func initScene(baseScene: UIWindowScene) {
        uiWindow = UIWindow(windowScene: baseScene)
    }

    func start() {
        let startup = ViewCoordinator(controller: navController)
        startup.start()

        uiWindow?.rootViewController = navController
        uiWindow?.makeKeyAndVisible()

        child.append(startup)
    }
}



