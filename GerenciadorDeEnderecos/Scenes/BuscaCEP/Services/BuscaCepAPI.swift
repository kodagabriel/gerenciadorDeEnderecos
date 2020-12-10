//
//  BuscaCepAPI.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 07/12/20.
//

import Foundation

enum errosNaBusca: Error {
    case cepNaoEncontrado
    case falhaNaConversao
}

class BuscaCepAPI: NSObject {
    func buscaEnderecoViaCEP(para cep: String, sucesso:@escaping(_ endereco: [String: Any]) -> Void, falha:@escaping(_ error: Error) -> Void) {
        guard let url = URL(string: "http://viacep.com.br/ws/\(cep)/json") else {return}
        var requisicao = URLRequest(url: url)
        requisicao.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: requisicao) { (data, response, error) in
            if error == nil {
                do {
                    guard let d = data else {return}
                    guard let data = try JSONSerialization.jsonObject(with: d, options: []) as? [String: String] else {
                        falha(errosNaBusca.cepNaoEncontrado)
                        return
                    }
                    sucesso(data)
                } catch {
                    falha(errosNaBusca.cepNaoEncontrado)
                }
            }
        }
        task.resume()
    }
}

