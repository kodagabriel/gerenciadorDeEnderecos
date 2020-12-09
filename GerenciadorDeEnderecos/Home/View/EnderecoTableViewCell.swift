//
//  EnderecoTableViewCell.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 07/12/20.
//

import UIKit

class EnderecoTableViewCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet weak var enderecoLabel: UILabel!
    @IBOutlet weak var cepLabel: UILabel!
    @IBOutlet weak var bairroCidadeEstadoLabel: UILabel!
    // MARK: Functions
    func configuraCelula(_ endereco: Endereco) {
        guard let logradouro = endereco.logradouro, let bairro = endereco.bairro, let cidade = endereco.cidade, let estado = endereco.estado else {return}
        enderecoLabel.text = "\(logradouro), \(endereco.numero)"
        cepLabel.text = endereco.cep
        bairroCidadeEstadoLabel.text = "\(bairro), \(cidade) - \(estado)"
    }
}
