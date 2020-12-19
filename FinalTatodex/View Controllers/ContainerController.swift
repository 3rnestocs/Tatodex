//
//  ContainerViewController.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/17/20.
//

import UIKit

class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureTatodexController()
    }
    
    func configureTatodexController() {
        
        let controller = UINavigationController.init(rootViewController: tatodexController)
        view.addSubview(controller.view)
        addChild(controller)
        controller.didMove(toParent: self)
    }
    
    func configureMenuViewController() {
    }
}
