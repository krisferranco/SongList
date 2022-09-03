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
    let dependencyManager: DependencyManager
    
    init() {
        navigationController = UINavigationController()
        rootViewController = nil
        dependencyManager = DependencyManager()
    }
    
    func start() {
        let viewController = UIViewController.instantiate(SongListViewController.self)
        rootViewController = viewController
        navigationController.setViewControllers([viewController], animated: true)
        
        let viewModel = SongListViewModel(dependencyManager: dependencyManager)
        viewController.bind(viewModel)
    }
}
