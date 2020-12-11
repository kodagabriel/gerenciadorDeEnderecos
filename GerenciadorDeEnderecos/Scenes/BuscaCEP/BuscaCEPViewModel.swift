//
//  BuscaCEPViewModel.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 10/12/20.
//

import UIKit

class BuscaCEPViewModel: NSObject {
    // MARK: Variables
    var travaDestravaButton: (() -> ()) = {}
    var limpaTextField: (() -> ()) = {}
    var seeDetailsOf: ((Endereco) -> ()) = {(_) in }
    // MARK: Functions
    func verificaSeCepEValido(_ cep: String) -> Bool {
        if cep.isEmpty {
            return false
        }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(cep).isSubset(of: nums)
    }
    func montaDic(_ endereco: Dictionary<String, Any>) -> Dictionary<String, Any> {
        guard let logradouro = endereco["logradouro"], let bairro = endereco["bairro"], let cidade = endereco["localidade"], let estado = endereco["uf"], let cep = endereco["cep"] else {return [:]}
        let id = String(describing: UUID())
        let dic: Dictionary<String, Any> = [
            "id": id,
            "logradouro": logradouro,
            "numero": "",
            "complemento": "",
            "bairro": bairro,
            "cidade": cidade,
            "estado": estado,
            "cep": cep
        ]
        return dic
    }
    func buscaCEP(para cep: String) {
        if verificaSeCepEValido(cep) {
            travaDestravaButton()
            BuscaCepAPI().buscaEnderecoViaCEP(para: cep) { [weak self](endereco: [String: Any]) in
                DispatchQueue.main.async {
                    self?.limpaTextField()
                    self?.travaDestravaButton()
                    guard let dicEndereco = self?.montaDic(endereco) else {return}
                    guard let endereco = EnderecoDAO().preparaEndereco(dicEndereco: dicEndereco) else {return}
                    self?.seeDetailsOf(endereco)
                }
            } falha: { (erro) in
                DispatchQueue.main.async { [weak self] in
                    self?.travaDestravaButton()
                }
                print(erro)
            }
        }
    }
}
