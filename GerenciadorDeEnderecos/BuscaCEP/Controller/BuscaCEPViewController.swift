//
//  BuscaCEPViewController.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 07/12/20.
//

import UIKit

class BuscaCEPViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var cepTextField: UITextField!
    @IBOutlet weak var buscarButton: UIButton!
    
    // MARK: ViewLyfeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraTextField()
    }
    
    // MARK: IBActions
    @IBAction func buscaCEPButton(_ sender: UIButton) {
        preparaBuscaCEP()
    }
    
    // MARK: Functions
    func configuraTextField() {
        cepTextField.addTarget(self, action: #selector(preparaBuscaCEP), for: .editingChanged)
    }
    func limpaTextField() {
            cepTextField.text = ""
        }
        
    func travaDestravaButton() {
        if buscarButton.isUserInteractionEnabled {
            buscarButton.isUserInteractionEnabled = false
        } else {
            buscarButton.isUserInteractionEnabled = true
        }
    }
    func montaDic(_ endereco: Dictionary<String, Any>) -> Dictionary<String, Any> {
        guard let logradouro = endereco["logradouro"], let bairro = endereco["bairro"], let cidade = endereco["localidade"], let estado = endereco["uf"], let cep = endereco["cep"] else {return [:]}
        let dic: Dictionary<String, Any> = [
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
    func verificaSeCepEValido(_ cep: String) -> Bool {
        if cep.isEmpty {
            return false
        }
        
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(cep).isSubset(of: nums)
    }
    @objc func preparaBuscaCEP() {
        guard let cep = cepTextField.text else {return}
        if cep.count == 8 {
            buscaCEP(para: cep)
        }
    }
    func buscaCEP(para cep: String) {
        guard let cep = cepTextField.text else {return} // tratar campo de CEP antes
        if verificaSeCepEValido(cep) {
            travaDestravaButton()
            BuscaCepAPI().buscaEnderecoViaCEP(para: cep) { [weak self](endereco: [String: Any]) in
                DispatchQueue.main.async {
                    self?.limpaTextField()
                    self?.travaDestravaButton()
                    let enderecoView = UIStoryboard(name: "DetalhesEndereco", bundle: nil).instantiateViewController(identifier: "DetalhesEndereco") as! DetalhesEnderecoViewController
                    let endereco = self?.montaDic(endereco)
                    enderecoView.endereco = endereco
                    self?.navigationController?.pushViewController(enderecoView, animated: true)
                }
            } falha: { (erro) in
                DispatchQueue.main.async {
                    self.travaDestravaButton()
                }
                print(erro)
            }
        }
    }
}

