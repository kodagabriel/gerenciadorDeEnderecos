//
//  HomeTableViewController.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 07/12/20.
//

import UIKit

class HomeTableViewController: UITableViewController, Storyboarded {
    // MARK: Variables
    let viewModel = HomeViewModel()
    weak var coordinator: MainCoordinator?
    // MARK: ViewLyfeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        doBindings()
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.recuperaEnderecos()
    }
    // MARK: IBActions
    @IBAction func addButton(_ sender: Any) {
        coordinator?.searchCEP()
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.enderecos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnderecoTableViewCell", for: indexPath) as! EnderecoTableViewCell
        cell.tag = indexPath.row
        cell.configuraCelula(viewModel.getEndereco(at: indexPath.row))
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(editarEndereco(_:)))
        cell.addGestureRecognizer(longPress)
        return cell
    }
    // MARK: Functions
    func doBindings() {
        viewModel.atualizaTabela = {[weak self] in self?.tableView.reloadData()}
        viewModel.seeDetailsOf = {[weak self] (endereco, isNew) in
            self?.coordinator?.seeAdressDetails(of: endereco, isNew: isNew)}
    }
    @objc func editarEndereco(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            viewModel.editarEndereco(tag: (longPress.view?.tag)!)
        }
    }
    
}
