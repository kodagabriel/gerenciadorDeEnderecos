//
//  EnderecoModelView.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 10/12/20.
//

import UIKit

class HomeModelView: NSObject {
    // MARK: Variables
    var enderecos: [Endereco] = []
    var atualizaTabela: (() -> ()) = {}
    var navegaPara: ((UIViewController, Bool) -> ()) = {_,_ in }
    // MARK: Functions
    func recuperaEnderecos() {
        enderecos = EnderecoDAO().recuperaEnderecos()
        atualizaTabela()
    }
    
    func editarEndereco(tag: Int) {
        let endereco = enderecos[tag]
        let detalhes = UIStoryboard(name: "DetalhesEndereco", bundle: nil).instantiateViewController(withIdentifier: "DetalhesEndereco") as! DetalhesEnderecoViewController
        detalhes.viewModel.endereco = endereco
        detalhes.viewModel.isNew = false
        navegaPara(detalhes, true)
    }
}
