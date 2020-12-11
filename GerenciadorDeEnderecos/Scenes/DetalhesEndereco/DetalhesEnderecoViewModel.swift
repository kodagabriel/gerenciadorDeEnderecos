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
    var popToRoot: (_ animated: Bool) -> () = {_ in}
    var present: (_ actions: UIAlertController, _ animated: Bool) -> () = {(_,_) in }
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
    func removeEndereco() {
        let actions = UIAlertController(title: "Deseja remover esse endereço?", message: "Essa ação é irreversível", preferredStyle: .alert)
        actions.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        actions.addAction(UIAlertAction(title: "Remover", style: .destructive, handler: { [weak self](_) in
            guard let endereco = self?.endereco else {return}
            EnderecoDAO().removeEndereco(endereco)
            self?.popToRoot(true)
        }))
        self.present(actions, true)
    }
    func buttonTitle() -> String {
        return isNew ? "Salvar" : "Atualizar"
    }
    func canDelete() -> Bool {
        return !isNew
    }
    func trataErros(erro: TextFieldStatus) -> String {
        switch erro {
        case .bairroVazio:
            return "Bairro não pode ser vazio"
        case .logradouroVazio:
            return "Logradouro não pode ser vazio"
        case .numeroVazio:
            return "Número não pode ser vazio"
        default:
            return ""
        }
    }
    func checaValores(logradouro: String, numero: String, bairro: String) -> TextFieldStatus {
        if (logradouro.isEmpty) {
            return .logradouroVazio
        }
        if numero.isEmpty {
            return .numeroVazio
        }
        if bairro.isEmpty {
            return .bairroVazio
        }
        return .allPassed
    }
    func getNumeroEndereco() -> String {
        guard let numero = endereco?.numero else {return ""}
        if (numero != 0) {
            return "\(numero)"
        }
        return ""
    }
    func cepUnicoParaCidade() -> Bool {
        guard let logradouro = endereco?.logradouro else {return true}
        if logradouro.isEmpty {
            return true
        } else {
            return false
        }
    }
}
