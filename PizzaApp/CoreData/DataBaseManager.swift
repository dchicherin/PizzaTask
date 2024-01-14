//
//  DataBaseManager.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 14/1/2567 BE.
//

import Foundation
import CoreData
import UIKit

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private init() {}
    
    func getAllMenuItems() -> [MenuItem] {
        //Получение всех записей для оффлайн-режима
        var menuItems: [MenuItem] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return menuItems
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MenuItemStored")
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            for data in result as! [NSManagedObject] {
                let id = data.value(forKey: "db_id") as? Int ?? 0
                let name = data.value(forKey: "name") as? String ?? ""
                let description = data.value(forKey: "desc") as? String ?? ""
                let price = data.value(forKey: "price") as? Int ?? 0
                let image = data.value(forKey: "image") as? String ?? ""
                let type = data.value(forKey: "type") as? String ?? ""
                
                let menuItem = MenuItem(id: id, name: name, description: description, price: price, image: image, type: type)
                menuItems.append(menuItem)
            }
        } catch {
            print("Failed to fetch menu items: \(error)")
        }
        
        return menuItems
    }
    func updateMenuItems(_ menuItems: [MenuItem]) {
        //Переписывание записей, используется при успешном получении данных из интернета
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            // Удаление
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MenuItemStored")
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            do {
                try managedContext.execute(deleteRequest)
            } catch {
                print("Failed to delete menu items: \(error)")
            }
            
            // Сохранение
            for menuItem in menuItems {
                let entity = NSEntityDescription.entity(forEntityName: "MenuItemStored", in: managedContext)!
                let menuItemObject = NSManagedObject(entity: entity, insertInto: managedContext)
                
                menuItemObject.setValue(menuItem.id, forKey: "db_id")
                menuItemObject.setValue(menuItem.name, forKey: "name")
                menuItemObject.setValue(menuItem.description, forKey: "desc")
                menuItemObject.setValue(menuItem.price, forKey: "price")
                menuItemObject.setValue(menuItem.image, forKey: "image")
                menuItemObject.setValue(menuItem.type, forKey: "type")
            }
            
            do {
                try managedContext.save()
            } catch {
                print("Failed to save menu items: \(error)")
            }
        }
}

