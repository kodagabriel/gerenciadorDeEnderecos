//
//  EnderecoViewController.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 07/12/20.
//

import UIKit



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
    var viewModel = DetalhesEnderecoViewModel()
    // MARK: ViewLyfeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraBotaoDeAcao()
        configuraBotaoDeletar()
        preencheTextFields()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: IBActions
    @IBAction func deletarRegistro(_ sender: UIButton) {
        guard let id = viewModel.endereco?["id"] as? String else {return}
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
        guard let userInfo = notification.userInfo else { return }
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 20
        scrollView.contentInset = contentInset
    }
    @objc func keyboardWillHide(notification:NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
           scrollView.contentInset = contentInset
    }
    func configuraBotaoDeAcao() {
        let button_tittle = viewModel.endereco?["id"] == nil ? "Salvar" : "Atualizar"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: button_tittle, style: .plain, target: self, action: #selector(salvar))
    }
    func configuraBotaoDeletar() {
        if viewModel.endereco?["id"] != nil {
            deletarButton.isHidden = false
        } else {
            deletarButton.isHidden = true
        }
    }
    @objc func salvar() {
        let textFieldStatus = checaTextFields()
        switch textFieldStatus {
        case .allPassed:
            guard let logradouro = logradouroTextField.text else {return}
            guard let numero_s = numeroTextField.text else {return}
            guard let complemento = complementoTextField.text else {return}
            guard let bairro = bairroTextField.text else {return}
            viewModel.salvaEndereco(logradouro: logradouro, numero_s: numero_s, complemento: complemento, bairro: bairro)
            navigationController?.popToRootViewController(animated: true)
            break
        default:
            trataErros(erro: textFieldStatus)
        }
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
    func preencheTextFields() {
        guard let end = viewModel.endereco else {return}
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
