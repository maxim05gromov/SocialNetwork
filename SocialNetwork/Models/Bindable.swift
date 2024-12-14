//
//  Bindable.swift
//  SocialNetwork
//
//  Created by Максим Громов on 12/14/24.
//

class Bindable<T> {
    var value: T? {
        didSet {
            print("didSet")
            handlers.forEach{ handler in
                handler(value)
            }
        }
    }
    private var handlers: [(T?) -> Void] = []
    func bind(_ handler: @escaping (T?) -> Void) {
        handlers.append(handler)
    }
}
