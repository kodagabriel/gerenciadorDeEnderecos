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
    func preparaEndereco(dicEndereco: Dictionary<String, Any>) -> Endereco?{
        var endereco:NSManagedObject?
        guard let id = UUID(uuidString: dicEndereco["id"] as! String) else {return nil}
        let enderecos = recuperaEnderecos().filter() {$0.id == id}
        if enderecos.count > 0 {
            guard let enderecoEncontrado = enderecos.first else {return nil}
            endereco = enderecoEncontrado
        } else {
            let entidade = NSEntityDescription.entity(forEntityName: "Endereco", in: contexto)
            endereco = NSManagedObject(entity: entidade!, insertInto: contexto)
        }
        endereco?.setValue(id, forKey: "id")
        
        var end: Endereco? = endereco as? Endereco
        end = preencheEndereco(end, com: dicEndereco)
        return end
    }
    func preencheEndereco(_ endereco: Endereco?, com dicEndereco: Dictionary<String, Any>) -> Endereco? {
        for (key, value) in dicEndereco {
            if key == "numero" {
                if let numero = value as? Int {
                    endereco?.setValue(numero, forKey: key)
                }
            } else {
                if key != "id" {
                    endereco?.setValue(value as? String, forKey: key)
                }
            }
        }
        return endereco
    }
    func salvarEndereco() {
        atualizaContexto()
    }
    private func atualizaContexto() {
        do {
            try contexto.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    private func removeAtualizacoesNaoSalvas() {
        if contexto.hasChanges {
            contexto.rollback()
        }
    }
    func recuperaEnderecos() -> Array<Endereco> {
        removeAtualizacoesNaoSalvas()
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
    func removeEndereco(_ endereco: Endereco) {
        contexto.delete(endereco)
        atualizaContexto()
    }
}
