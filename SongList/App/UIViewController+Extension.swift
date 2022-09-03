//
//  UIViewController+Extension.swift
//  SongList
//
//  Created by Kristhoffer Ferranco on 9/4/22.
//

import UIKit

/**
 Convinience method in initializing VC with defined type
 Can support multiple storyboard by passing a value for 'storyboardName', default storyboard is Main.storyboard
 Make sure that Storyboard ID of ViewController is defined in storyboard same as its class name
 */
extension UIViewController {
    static func instantiate<T>(_ type: T.Type, storyboardName: String = "Main") -> T {
        let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: String(describing: T.self)) as? T
        else {
            fatalError("Failed to initialized ViewController")
        }
        return viewController
    }
}
