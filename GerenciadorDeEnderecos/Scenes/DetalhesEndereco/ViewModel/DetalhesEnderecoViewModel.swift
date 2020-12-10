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
    var endereco: [String: Any]?
    // MARK: Functions
    func montaDicEndereco(logradouro: String, numero_s: String, complemento: String, bairro: String) -> Dictionary<String, Any> {
        var id = ""
        if endereco?["id"] == nil {
            id = String(describing: UUID())
        } else {
            guard let id_existente = endereco?["id"] else {return [:]}
            id = String(describing: id_existente)
        }
        guard let numero = Int(numero_s) else {return [:]}
        endereco?["id"] = id
        endereco?["logradouro"] = logradouro
        endereco?["numero"] = numero
        endereco?["complemento"] = complemento
        endereco?["bairro"] = bairro
        return endereco ?? [:]
    }
    func salvaEndereco(logradouro: String, numero_s: String, complemento: String, bairro: String) {
        EnderecoDAO().salvarEndereco(dicEndereco: montaDicEndereco(logradouro: logradouro, numero_s: numero_s, complemento: complemento, bairro: bairro))
    }
}
