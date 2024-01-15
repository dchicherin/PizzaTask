//
//  ViewPresenter.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 14/1/2567 BE.
//

import Foundation
import UIKit

protocol ViewPresenterInput {
    func showInitData(menuItems: [MenuItem])
    func setRowToUpdate(menuPositionForImage: MenuItem, image: UIImage)
    func initScrolling(tag: Int, menuItems: [MenuItem])
    func updateHeights(heightConstrain: CGFloat, spacerContrant: CGFloat, offsetY: CGFloat)
}
class ViewPresenter: ViewPresenterInput {
    func setRowToUpdate(menuPositionForImage: MenuItem, image: UIImage) {
        controller?.updateRowImage(menuPositionForImage: menuPositionForImage, image: image)
    }
    
    let controller: ViewControllerOutput?
    
    init(controller: ViewControllerOutput) {
        self.controller = controller
    }
    func showInitData(menuItems: [MenuItem]) {
        controller?.updateInfo(menuItems: menuItems)
    }
    func initScrolling(tag: Int, menuItems: [MenuItem]){
        var index = 0
        switch tag {
        case 0:
            index = menuItems.firstIndex(where: {$0.type == "pizza"}) ?? 0
        case 1:
            index = menuItems.firstIndex(where: {$0.type == "combo"}) ?? 0
        case 2:
            index = menuItems.firstIndex(where: {$0.type == "desert"}) ?? 0
        case 3:
            index = menuItems.firstIndex(where: {$0.type == "drink"}) ?? 0
        default:
            index = 0
        }
        
        let indexPath = IndexPath(row: index, section: 0)
        controller?.scrollToCategory(indexPath: indexPath)
    }
    func updateHeights(heightConstrain: CGFloat, spacerContrant: CGFloat, offsetY: CGFloat){
        //При скролле вниз потихоньку скрываем баннер
        let offset = offsetY
        var diff = -offset
        if(offset > 10){
            diff /= 20
        }
        var newHeight = heightConstrain + diff
        var newSpacer = spacerContrant + newHeight
        if newHeight < 0 {
            newSpacer = newSpacer > 0 ? newSpacer : 0
            newHeight = 0
            
        } else if newHeight > Constants.shared.collectionViewHeight { // or whatever
            newHeight = Constants.shared.collectionViewHeight
        }
        if newSpacer > Constants.shared.elementSpacing {
            newSpacer = Constants.shared.elementSpacing
        }
        controller?.setHeightAndSpace(newSpacer: newSpacer, newHeight: newHeight)
    }
}
