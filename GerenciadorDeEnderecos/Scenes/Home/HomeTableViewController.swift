//
//  HomeTableViewController.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 07/12/20.
//

import UIKit

class HomeTableViewController: UITableViewController {
    // MARK: Variables
    let modelView = HomeModelView()
    
    // MARK: ViewLyfeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        doBindings()
    }
    override func viewWillAppear(_ animated: Bool) {
        modelView.recuperaEnderecos()
    }
    
    // MARK: IBActions
    @IBAction func addButton(_ sender: Any) {
        let view = UIStoryboard(name: "BuscaCEP", bundle: nil).instantiateViewController(withIdentifier: "BuscaCEP") as! BuscaCEPViewController
        self.navigationController?.pushViewController(view, animated: true)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelView.enderecos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnderecoTableViewCell", for: indexPath) as! EnderecoTableViewCell
        cell.tag = indexPath.row
        cell.configuraCelula(modelView.enderecos[indexPath.row])
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(editarEndereco(_:)))
        cell.addGestureRecognizer(longPress)
        return cell
    }
    
    // MARK: Functions
    func doBindings() {
        modelView.atualizaTabela = {[weak self] in self?.tableView.reloadData()}
        modelView.navegaPara = {[weak self] (view, animated) in self?.navigationController?.pushViewController(view, animated: animated)}
    }
    @objc func editarEndereco(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            modelView.editarEndereco(tag: (longPress.view?.tag)!)
        }
    }
    
}
