//
//  AsyncOperation.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 14/1/2567 BE.
//


import Foundation

class AsyncOperation : Operation {
    //Определение для асинхронных операций для подгрузки картинок
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }
    
    enum State : String {
        case ready, executing, finished
        
        var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool  {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    private var _isCanceled = false {
        willSet {
            willChangeValue(forKey: "isCancelled")
        }
        didSet {
            didChangeValue(forKey: "isCancelled")
        }
    }
    override var isCancelled: Bool {
        get {
            return _isCanceled
        }
    }
    
    override func start() {
        guard isCancelled == false else {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        _isCanceled = true
    }
}
