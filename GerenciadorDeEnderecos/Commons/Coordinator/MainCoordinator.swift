//
//  MainCoordinator.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 11/12/20.
//

import UIKit

class MainCoordinator: NSObject, Coordinator, UINavigationControllerDelegate {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init (navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    func start() {
        let view = HomeTableViewController.instantiate()
        view.coordinator = self
        navigationController.delegate = self
        navigationController.pushViewController(view, animated: true)
    }
    func searchCEP() {
        let view = BuscaCEPViewController.instantiate()
        view.coordinator = self
        navigationController.pushViewController(view, animated: true)
    }
    func seeAdressDetails(of adress: Endereco, isNew: Bool = true) {
        let view = DetalhesEnderecoViewController.instantiate()
        view.coordinator = self
        view.viewModel.endereco = adress
        view.viewModel.isNew = isNew
        navigationController.pushViewController(view, animated: true)
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let from = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        if navigationController.viewControllers.contains(from) {
            return
        }
        if from is DetalhesEnderecoViewController {
            EnderecoDAO().removeAtualizacoesNaoSalvas()
            return
        }
        if from is BuscaCEPViewController {
            EnderecoDAO().removeAtualizacoesNaoSalvas()
            return
        }
    }
}
