//
//  SongListCoordinator.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/3/22.
//

import Foundation
import UIKit

class Coordinator {
    
    let navigationController: UINavigationController
    var rootViewController: UIViewController?
    
    init() {
        navigationController = UINavigationController()
        rootViewController = nil
        
        DependencyContainer.shared.register(DependencyManagerProtocol.self, service: DependencyManager())
    }
    
    func start() {
        let viewController = UIViewController.instantiate(SongListViewController.self)
        rootViewController = viewController
        navigationController.setViewControllers([viewController], animated: true)
        
        let viewModel = SongListViewModel()
        viewController.bind(viewModel)
    }
}
