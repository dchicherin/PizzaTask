//
//  ViewInteractor.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 14/1/2567 BE.
//

import Foundation
import UIKit

protocol ViewInteractorInput {
    func fetchData()
    func initScrolling(tag: Int, menuItems: [MenuItem])
    func updateHeights(heightConstrain: CGFloat, spacerContrant: CGFloat, offsetY: CGFloat)
}
class ViewInteractor: ViewInteractorInput{
    //Интерактор с бизнес-логикой
    let presenter: ViewPresenterInput?
    var menuItems = [MenuItem]()
    var imagesDict: [Int: UIImage] = [:]

    init(presenter: ViewPresenterInput) {
        self.presenter = presenter
    }
    func fetchData() {
        let myFetch = MenuFetcher(networkClient: NetworkClient())
        
        myFetch.getMenuItems() { data in
            if data.isEmpty {
                self.menuItems = DatabaseManager.shared.getAllMenuItems()
            } else {
                self.menuItems = data
                DatabaseManager.shared.updateMenuItems(data)
            }
            //Сортирвка для соответствия категориям
            self.menuItems.sort { (item1, item2) -> Bool in
                let typeOrder: [String] = ["pizza", "combo", "desert", "drink"]
                guard let index1 = typeOrder.firstIndex(of: item1.type),
                      let index2 = typeOrder.firstIndex(of: item2.type) else {
                    return false
                }
                return index1 < index2
            }
            self.presenter?.showInitData(menuItems: self.menuItems)
            //Асинхронная подгрузка картинок
            self.downloadImages(imagesToLoad: data)
        }
        
    }
    func downloadImages(imagesToLoad: [MenuItem]){
        //Загрузка изображений асинхронно
        let queueAsync = OperationQueue()
        for schedulePositonForImage in imagesToLoad{
            let downloadOperation = DownloadOperation(url: schedulePositonForImage.image )
            downloadOperation.completionBlock = {
                DispatchQueue.main.async {
                    guard let data =  downloadOperation.outputImage
                    else {
                        return
                    }
                    guard let imageUI = UIImage(data: data)
                    else {
                        return
                    }
                    self.imagesDict[schedulePositonForImage.id] = imageUI
                    //Обновляем только нужную строчку
                    self.presenter?.setRowToUpdate(menuPositionForImage: schedulePositonForImage, image: imageUI)
                    
                }
            }
            queueAsync.addOperation(downloadOperation)
        }
    }
    func initScrolling(tag: Int, menuItems: [MenuItem]) {
        presenter?.initScrolling(tag: tag, menuItems: menuItems)
    }
    func updateHeights(heightConstrain: CGFloat, spacerContrant: CGFloat, offsetY: CGFloat){
        presenter?.updateHeights(heightConstrain: heightConstrain, spacerContrant: spacerContrant, offsetY: offsetY)
    }
}
