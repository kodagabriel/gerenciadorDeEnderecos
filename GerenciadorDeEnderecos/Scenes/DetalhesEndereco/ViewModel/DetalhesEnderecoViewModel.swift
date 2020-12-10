//
//  DetalhesEnderecoViewModel.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 10/12/20.
//

import UIKit

enum TextFieldStatus {
    case logradouroVazio
    case numeroVazio
    case bairroVazio
    case allPassed
}

class DetalhesEnderecoViewModel: NSObject {
    // MARK: Variables
    var endereco: Endereco?
    var isNew = true
    // MARK: Functions
    func montaDicEndereco(logradouro: String, numero_s: String, complemento: String, bairro: String) -> Dictionary<String, Any> {
        guard let numero = Int(numero_s) else {return [:]}
        let dicEndereco: Dictionary<String, Any> = [
            "logradouro": logradouro,
            "numero": numero,
            "complemento": complemento,
            "bairro": bairro,
        ]
        return dicEndereco
    }
    func salvaEndereco(logradouro: String, numero_s: String, complemento: String, bairro: String) {
        endereco = EnderecoDAO().preencheEndereco(endereco, com: montaDicEndereco(logradouro: logradouro, numero_s: numero_s, complemento: complemento, bairro: bairro))
        EnderecoDAO().salvarEndereco()
    }
}
