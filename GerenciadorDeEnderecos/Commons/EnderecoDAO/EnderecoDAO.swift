//
//  EnderecoDAO.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 07/12/20.
//

import UIKit
import CoreData

class EnderecoDAO: NSObject {
    // MARK: Variables
    var contexto:NSManagedObjectContext {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
    }
    // MARK: Functions
    func salvarEndereco(dicEndereco: Dictionary<String, Any>) {
        var endereco:NSManagedObject?
        guard let id = UUID(uuidString: dicEndereco["id"] as! String) else {return}
        let enderecos = recuperaEnderecos().filter() {$0.id == id}
        if enderecos.count > 0 {
            guard let enderecoEncontrado = enderecos.first else {return}
            endereco = enderecoEncontrado
        } else {
            let entidade = NSEntityDescription.entity(forEntityName: "Endereco", in: contexto)
            endereco = NSManagedObject(entity: entidade!, insertInto: contexto)
        }
        endereco?.setValue(id, forKey: "id")
        endereco?.setValue(dicEndereco["logradouro"] as? String, forKey: "logradouro")
        endereco?.setValue(dicEndereco["complemento"] as? String, forKey: "complemento")
        endereco?.setValue(dicEndereco["bairro"] as? String, forKey: "bairro")
        endereco?.setValue(dicEndereco["cidade"] as? String, forKey: "cidade")
        endereco?.setValue(dicEndereco["estado"] as? String, forKey: "estado")
        endereco?.setValue(dicEndereco["cep"], forKey: "cep")
        guard let numero = dicEndereco["numero"] as? Int else {return}
        endereco?.setValue(numero, forKey: "numero")
        atualizaContexto()
    }
    private func atualizaContexto() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    func recuperaEnderecos() -> Array<Endereco> {
        let pesquisa:NSFetchRequest<Endereco> = Endereco.fetchRequest()
        pesquisa.sortDescriptors = [NSSortDescriptor(key: "logradouro", ascending: true)]
        let gerenciaResultados:NSFetchedResultsController<Endereco> = NSFetchedResultsController(fetchRequest: pesquisa, managedObjectContext: contexto, sectionNameKeyPath: nil, cacheName: nil)
        do {
            try gerenciaResultados.performFetch()
        } catch {
            print(error.localizedDescription)
        }
        guard let lista = gerenciaResultados.fetchedObjects else {return []}
        return lista
    }
    func removeEndereco(_ id: String) {
        guard let id = UUID(uuidString: id) else {return}
        let enderecos = recuperaEnderecos().filter() {$0.id == id}
        guard let endereco = enderecos.first else {return}
        contexto.delete(endereco)
        atualizaContexto()
    }
}
