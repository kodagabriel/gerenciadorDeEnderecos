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
        doBinding()
        checaSeCepUnicoDaCidade()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:UIResponder.keyboardWillHideNotification, object: nil)
    }
    // MARK: IBAction
    @IBAction func deletarRegistro(_ sender: UIButton) {
        self.viewModel.removeEndereco()
    }
    // MARK: Functions
    func doBinding() {
        self.viewModel.popToRoot = {[weak self] animated in self?.navigationController?.popToRootViewController(animated: animated)}
        self.viewModel.present = {[weak self] (actions, animated) in
            self?.present(actions, animated: animated, completion: nil)
        }
    }
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: viewModel.buttonTitle(), style: .plain, target: self, action: #selector(salvar))
    }
    func configuraBotaoDeletar() {
        if viewModel.canDelete() {
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
        errorLabel.text = viewModel.trataErros(erro: erro)
    }
    func checaTextFields() -> TextFieldStatus {
        guard let logradouro = logradouroTextField.text else {return .logradouroVazio}
        guard let numero = numeroTextField.text else {return .numeroVazio}
        guard let bairro = bairroTextField.text else {return .bairroVazio}
        return viewModel.checaValores(logradouro: logradouro, numero: numero, bairro: bairro)
    }
    func preencheTextFields() {
        logradouroTextField.text = viewModel.endereco?.logradouro
        bairroTextField.text = viewModel.endereco?.bairro
        cidadeTextField.text = viewModel.endereco?.cidade
        estadoTextField.text = viewModel.endereco?.estado
        numeroTextField.text = viewModel.getNumeroEndereco()
        complementoTextField.text = viewModel.endereco?.complemento
        cepTextField.text = viewModel.endereco?.cep
    }
    func checaSeCepUnicoDaCidade() {
        if viewModel.cepUnicoParaCidade() {
            logradouroTextField.isUserInteractionEnabled = true
            bairroTextField.isUserInteractionEnabled = true
        }
    }
}

