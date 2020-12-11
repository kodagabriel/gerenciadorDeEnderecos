//
//  Storyboarded.swift
//  GerenciadorDeEnderecos
//
//  Created by Usemobile Tecnologia on 11/12/20.
//

import UIKit

protocol Storyboarded {
    static func instantiate() -> Self
}

extension Storyboarded {
    static func instantiate() -> Self {
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: id, bundle: Bundle.main)
        return storyboard.instantiateViewController(withIdentifier: id) as! Self
    }
}
