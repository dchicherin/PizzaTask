//
//  Network.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 13/1/2567 BE.
//


import Foundation

class MenuFetcher {
    //Получение меню из мок-точки
    private var networkClient: NetworkClient?
    
    init(networkClient: NetworkClient? = nil) {
        self.networkClient = networkClient
    }

    func getMenuItems(completion: @escaping([MenuItem])->Void) {
        self.networkClient?.outCompletionHandler = { result  in
            switch result {
            case .success(let data):
                //print(data)
                if let content = try?  JSONDecoder().decode([MenuItem].self, from: data) {
                    completion(content)
                    //print(content)
                }
            default:
                print("Network error")
                break
            }
            
        }
        networkClient?.request(path: "https://65a27de942ecd7d7f0a7b42f.mockapi.io/api/pizza/pizzas") { (result: Result<[MenuItem],Error>) in
            switch result {
            case .success(let data) :
                completion(data)
            case .failure(let error):
                completion([MenuItem]())
            }
        }
    }
}
