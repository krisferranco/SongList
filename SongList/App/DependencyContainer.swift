//
//  DependencyContainer.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/5/22.
//

import Foundation

class DependencyContainer {
    
    static let shared = DependencyContainer()
    
    var services: [String: Any] = [:]
    
    private init() {}
 
    func register<T>(_ type: T.Type, service: T) {
        services[String(describing: T.self)] = service
    }
    
    func resolve<T>(_ type: T.Type) -> T? {
        return services[String(describing: T.self)] as? T
    }
}

@propertyWrapper public struct Inject<T: Any> {
    public var component: T!

    public init(name: String? = nil) {
        component = DependencyContainer.shared.resolve(T.self)
    }

    public var wrappedValue: T {
        get { return component }
        mutating set { component = newValue }
    }
}



