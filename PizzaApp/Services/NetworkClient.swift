//
//  NetworkClient.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 13/1/2567 BE.
//

import Foundation

class NetworkClient : NSObject {
    //Класс для сетевых запросов
    private let jsonDecoder = JSONDecoder()
    
    var outCompletionHandler: ((Result<Data,Error>)->Void)? = nil
    
    
    
    //Конфигурация
    lazy var  configuration: URLSessionConfiguration =  {
        let configuration =  URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 15
        return configuration
    }()
    
    lazy var operationQueue: OperationQueue = {
       let operationQueue = OperationQueue()
        operationQueue.qualityOfService = .background
        return operationQueue
    }()
    
    lazy var urlSession: URLSession? = {
        return URLSession.init(configuration: configuration, delegate: self, delegateQueue: operationQueue)
    }()
    
    private var dataTask: URLSessionDataTask? = nil
    
    func request<T:Codable>(path: String, completion: @escaping(Result<T,Error>)->Void) {
        guard let url = URL(string: path) else {
            return
        }
        let urlRequest = URLRequest(url: url)
  
        self.dataTask = urlSession?.dataTask(with: urlRequest, completionHandler: { [weak self] data, response, error in
            guard let self = self else {return}
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            } else {
                if let respn = response as? HTTPURLResponse, respn.statusCode < 200 && respn.statusCode >= 400 {
                    //error
                    DispatchQueue.main.async {
                        print("error")
                    }
                }
            }
            if let data = data {
                do{
                    let content = try self.jsonDecoder.decode(T.self, from: data)
                    DispatchQueue.main.async {
                        
                        completion(.success(content))
                    }
                }catch{
                    print(error)
                }
            }
        })
        self.dataTask?.resume()
    }
    
}

extension NetworkClient : URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        DispatchQueue.main.async {
            self.outCompletionHandler?(.success(data))
        }
    }
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
    }
}
