//
//  MenuItem.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 13/1/2567 BE.
//

import Foundation
struct MenuItem: Codable {
    //Структура для получения данных из json
    let id: Int
    let name: String
    let description: String
    let price: Int
    let image: String
    let type: String
}
