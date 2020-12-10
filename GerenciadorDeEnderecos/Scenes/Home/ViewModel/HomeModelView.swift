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
    // MARK: Functions
    func recuperaEnderecos() {
        enderecos = EnderecoDAO().recuperaEnderecos()
        atualizaTabela()
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
