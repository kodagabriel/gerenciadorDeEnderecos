//
//  EnderecoModelView.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 10/12/20.
//

import UIKit

class HomeViewModel: NSObject {
    // MARK: Variables
    var enderecos: [Endereco] = []
    var atualizaTabela: (() -> ()) = {}
    var seeDetailsOf: ((Endereco, Bool) -> ()) = {(_,_) in }
    // MARK: Functions
    func recuperaEnderecos() {
        enderecos = EnderecoDAO().recuperaEnderecos()
        atualizaTabela()
    }
    
    func getEndereco(at index: Int) -> Endereco{
        return enderecos[index]
    }
    
    func editarEndereco(tag: Int) {
        let endereco = getEndereco(at: tag)
        seeDetailsOf(endereco, false)
    }
}
