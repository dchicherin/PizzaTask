//
//  StoryBoardExt.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 14/1/2567 BE.
//

import Foundation
import UIKit

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
