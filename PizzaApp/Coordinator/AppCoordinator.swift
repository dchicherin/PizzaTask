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
protocol Coordinator {
    var parent: Coordinator? { get set }
    var child: [Coordinator] { get set }

    func start()
}
import Foundation
import UIKit


class ViewCoordinator: Coordinator {
    var parent: Coordinator? = nil
    var child: [Coordinator] = []

    private let navController: UINavigationController

    init(controller: UINavigationController) {
        navController = controller
    }

    func start() {
        let controller = ViewModuleBuilder.buid(output: self)
        navController.pushViewController(controller, animated: false)
    }
}

final class ViewModuleBuilder {
    static func buid(output: AnyObject?) -> UIViewController{
        let controller: ViewController = Storyboard.defaultStoryboard.buildViewController()
        Configurator.configure(viewController: controller)
        return controller
    }
}
enum Storyboard: String {
    case main = "Main"

    static var defaultStoryboard: UIStoryboard {
        return UIStoryboard(name: Storyboard.main.rawValue, bundle: nil)
    }
}

extension UIStoryboard {
    func buildViewController<T>(controllerName: String = String(describing: T.self)) -> T {
        return instantiateViewController(withIdentifier: controllerName) as! T
    }
}
class Configurator {
    static func configure(viewController: UIViewController) {
        if let controller = viewController as? ViewController {
            let presenter = ViewPresenter(controller: controller)
            let interactor = ViewInteractor(presenter: presenter)
            controller.interactor = interactor
        }
    }
}
