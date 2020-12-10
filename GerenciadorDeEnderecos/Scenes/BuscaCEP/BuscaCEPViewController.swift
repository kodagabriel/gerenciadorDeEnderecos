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
    // MARK: Variables
    let viewModel = BuscaCEPViewModel()
    // MARK: ViewLyfeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configuraTextField()
        hideKeyboardWhenTappedAround()
        doBinding()
    }
    // MARK: IBActions
    @IBAction func buscaCEPButton(_ sender: UIButton) {
        preparaBuscaCEP()
    }
    // MARK: Functions
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            tap.cancelsTouchesInView = false
         view.addGestureRecognizer(tap)
    }
    func doBinding() {
        viewModel.travaDestravaButton = {[weak self] in self?.travaDestravaButton()}
        viewModel.navegaPara = {[weak self] (view, animated) in
            self?.navigationController?.pushViewController(view, animated: animated)}
        viewModel.travaDestravaButton = {[weak self] in self?.travaDestravaButton()}
    }
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
    @objc func preparaBuscaCEP() {
        guard let cep = cepTextField.text else {return}
        if cep.count == 8 {
            viewModel.buscaCEP(para: cep)
        }
    }
}

