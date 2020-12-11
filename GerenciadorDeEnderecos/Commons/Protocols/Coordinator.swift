//
//  Coordinator.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 11/12/20.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
