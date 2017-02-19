//
//  AlertCenter.swift
//  WeatherStation
//
//  Created by Kostiantyn Dovbush on 19/01/2017.
//  Copyright © 2017 Kostiantyn Dovbush. All rights reserved.
//

import UIKit

typealias ActionClosure = () -> Void

extension UIViewController {

    func presentRequiredFieldsAlert() {
        let okAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        presentAlert(with: "Required Fields Are Missing", message: "Name and Address can't be empty", style: .alert, actions: [okAction])
    }
    
    func presentConnectionErrorAlert(addAnywayAction: @escaping ActionClosure, cancelAction: @escaping ActionClosure) {
        let addAnywayAction = UIAlertAction(title: "Add anyway", style: .default, handler: { action in
            addAnywayAction()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            cancelAction()
        })
        
        presentAlert(with: "This station is offline", message: "Please check address and try again", style: .actionSheet, actions: [addAnywayAction, cancelAction])
    }
    
    func presentCantCreateStation() {
        let okAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        presentAlert(with: "Can't add station", message: "Something went wrong", style: .alert, actions: [okAction])
    }
    
    func presentAlreadyPresentStation() {
        let okAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        presentAlert(with: "Station can't be added", message: "Station with this address already exists", style: .alert, actions: [okAction])
    }
    
    
    func presentAlert(with title: String, message: String, style: UIAlertControllerStyle, actions: [UIAlertAction]) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alertView.addAction(action)
        }
        
        present(alertView, animated: true, completion: nil)
    }
    
}
