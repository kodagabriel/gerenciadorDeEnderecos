//
//  HomeTableViewController.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 07/12/20.
//

import UIKit

class HomeTableViewController: UITableViewController {
    // MARK: IBOutlets
    // MARK: Variables
    var enderecos: [Endereco] = []
    // MARK: ViewLyfeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        recuperaEnderecos()
    }
    // MARK: IBActions
    @IBAction func addButton(_ sender: Any) {
        let view = UIStoryboard(name: "BuscaCEP", bundle: nil).instantiateViewController(identifier: "BuscaCEP") as! BuscaCEPViewController
        self.navigationController?.pushViewController(view, animated: true)
    }
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return enderecos.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EnderecoTableViewCell", for: indexPath) as! EnderecoTableViewCell
        cell.tag = indexPath.row
        cell.configuraCelula(enderecos[indexPath.row])
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(editarEndereco(_:)))
        cell.addGestureRecognizer(longPress)
        // perguntar se preciso ter um main ou se posso colocar a tela principal direto na pasta view da scene home20730577044
        return cell
    }
    // MARK: Functions
    func recuperaEnderecos() {
        enderecos = EnderecoDAO().recuperaEnderecos()
        tableView.reloadData()
    }
    @objc func editarEndereco(_ longPress: UILongPressGestureRecognizer) {
        if longPress.state == .began {
            let endereco = enderecos[(longPress.view?.tag)!]
            let detalhes = UIStoryboard(name: "DetalhesEndereco", bundle: nil).instantiateViewController(withIdentifier: "DetalhesEndereco") as! DetalhesEnderecoViewController
            detalhes.endereco = montaDic(endereco: endereco)
            navigationController?.pushViewController(detalhes, animated: true)
        }
    }
    func montaDic(endereco: Endereco) -> Dictionary<String,Any>{
        guard let id = endereco.id, let logradouro = endereco.logradouro, let complemento = endereco.complemento, let bairro = endereco.bairro, let cidade = endereco.cidade, let estado = endereco.estado, let cep = endereco.cep else {return [:]}
        let dic: Dictionary<String, Any> = [
            "id": String(describing: id),
            "logradouro": logradouro,
            "numero": endereco.numero,
            "complemento": complemento,
            "bairro": bairro,
            "cidade": cidade,
            "estado": estado,
            "cep": cep
        ]
        return dic
    }
}
