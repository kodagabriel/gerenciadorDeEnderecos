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
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: IBAction
    @IBAction func deletarRegistro(_ sender: UIButton) {
        let actions = UIAlertController(title: "Deseja remover esse endereço?", message: "Essa ação é irreversível", preferredStyle: .alert)
        actions.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        actions.addAction(UIAlertAction(title: "Remover", style: .destructive, handler: { [weak self](_) in
            guard let endereco = self?.viewModel.endereco else {return}
            EnderecoDAO().removeEndereco(endereco)
            self?.navigationController?.popToRootViewController(animated: true)
        }))
        self.present(actions, animated: true, completion: nil)
    }
    // MARK: Functions
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            tap.cancelsTouchesInView = false
         view.addGestureRecognizer(tap)
    }
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
        let button_tittle = viewModel.isNew ? "Salvar" : "Atualizar"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: button_tittle, style: .plain, target: self, action: #selector(salvar))
    }
    func configuraBotaoDeletar() {
        if viewModel.isNew {
            deletarButton.isHidden = true
        } else {
            deletarButton.isHidden = false
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
        logradouroTextField.text = viewModel.endereco?.logradouro
        bairroTextField.text = viewModel.endereco?.bairro
        cidadeTextField.text = viewModel.endereco?.cidade
        estadoTextField.text = viewModel.endereco?.estado
        guard let numero = viewModel.endereco?.numero else {return}
        if (numero != 0) {
            numeroTextField.text = "\(numero)"
        }
        complementoTextField.text = viewModel.endereco?.complemento
        cepTextField.text = viewModel.endereco?.cep
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

