//
//  EnderecoViewController.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 07/12/20.
//

import UIKit

enum TextFieldStatus {
    case logradouroVazio
    case numeroVazio
    case bairroVazio
    case allPassed
}

class DetalhesEnderecoViewController: UIViewController {
    // MARK: IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var logradouroTextField: UITextField!
    @IBOutlet weak var numeroTextField: UITextField!
    @IBOutlet weak var complementoTextField: UITextField!
    @IBOutlet weak var bairroTextField: UITextField!
    @IBOutlet weak var cidadeTextField: UITextField!
    @IBOutlet weak var estadoTextField: UITextField!
    @IBOutlet weak var cepTextField: UITextField!
    @IBOutlet weak var deletarButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    // MARK: Variables
    var endereco: [String: Any]?
    // MARK: ViewLyfeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraBotaoDeAcao()
        configuraBotaoDeletar()
        inicializaTextFields()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: IBActions
    @IBAction func deletarRegistro(_ sender: UIButton) {
        guard let id = endereco?["id"] as? String else {return}
        let actions = UIAlertController(title: "Deseja remover esse endereço?", message: "Essa ação é irreversível", preferredStyle: .alert)
        actions.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        actions.addAction(UIAlertAction(title: "Remover", style: .destructive, handler: { [weak self](_) in
            EnderecoDAO().removeEndereco(id)
            self?.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(actions, animated: true, completion: nil)
        
    }
    // MARK: Functions
    @objc func keyboardWillShow(notification:NSNotification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    func adjustInsetForKeyboardShow(_ show: Bool, notification: NSNotification) {
      guard
        let userInfo = notification.userInfo,
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]
          as? NSValue
        else {
          return
      }
        
      let adjustmentHeight = (keyboardFrame.cgRectValue.height + 20) * (show ? 1 : -1)
      scrollView.contentInset.bottom += adjustmentHeight
      scrollView.verticalScrollIndicatorInsets.bottom += adjustmentHeight
    }
    func configuraBotaoDeAcao() {
        let button_tittle = endereco?["id"] == nil ? "Salvar" : "Atualizar"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: button_tittle, style: .plain, target: self, action: #selector(salvar))
    }
    func configuraBotaoDeletar() {
        if endereco?["id"] != nil {
            deletarButton.isHidden = false
        } else {
            deletarButton.isHidden = true
        }
    }
    @objc func salvar() {
        let textFieldStatus = checaTextFields()
        switch textFieldStatus {
        case .allPassed:
            EnderecoDAO().salvarEndereco(dicEndereco: montaDicEndereco())
            navigationController?.popToRootViewController(animated: true)
            break
        default:
            trataErros(erro: textFieldStatus)
        }
    }
    func montaDicEndereco() -> Dictionary<String, Any> {
        var id = ""
        if endereco?["id"] == nil {
            id = String(describing: UUID())
        } else {
            guard let id_existente = endereco?["id"] else {return [:]}
            id = String(describing: id_existente)
        }
        guard let logradouro = logradouroTextField.text else {return [:]}
        guard let numero_s = numeroTextField.text, let numero = Int(numero_s) else {return [:]}
        guard let complemento = complementoTextField.text else {return [:]}
        guard let bairro = bairroTextField.text else {return [:]}
        guard let cidade = cidadeTextField.text else {return [:]}
        guard let estado = estadoTextField.text else {return [:]}
        guard let cep = cepTextField.text else {return [:]}
        // REFATORAR
        let dic: Dictionary<String, Any> = [
            "id": id,
            "logradouro": logradouro,
            "numero": numero,
            "complemento": complemento,
            "bairro": bairro,
            "cidade": cidade,
            "estado": estado,
            "cep": cep
        ]
        return dic
    }
    func trataErros(erro: TextFieldStatus) {
        switch erro {
        case .bairroVazio:
            errorLabel.text = "Bairro não pode ser vazio"
            break
        case .logradouroVazio:
            errorLabel.text = "Logradouro não pode ser vazio"
            break
        case .numeroVazio:
            errorLabel.text = "Número não pode ser vazio"
            break
        default:
            errorLabel.text = ""
        }
    }
    func checaTextFields() -> TextFieldStatus {
        guard let logradouro = logradouroTextField.text else {return .logradouroVazio}
        guard let numero = numeroTextField.text else {return .numeroVazio}
        guard let bairro = bairroTextField.text else {return .bairroVazio}
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
    func inicializaTextFields() {
        guard let end = endereco else {return}
        logradouroTextField.text = end["logradouro"] as? String
        bairroTextField.text = end["bairro"] as? String
        cidadeTextField.text = end["cidade"] as? String
        estadoTextField.text = end["estado"] as? String
        numeroTextField.text = String(describing: end["numero"]!)
        complementoTextField.text = end["complemento"] as? String
        cepTextField.text = end["cep"] as? String
        checaSeCepUnicoDaCidade()
    }
    func checaSeCepUnicoDaCidade() {
        guard let logradouro = logradouroTextField.text else {return}
        if logradouro.isEmpty {
            logradouroTextField.isUserInteractionEnabled = true
            bairroTextField.isUserInteractionEnabled = true
        }
    }
}
