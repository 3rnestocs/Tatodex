//
//  EmptyView.swift
//  FinalTatodex
//
//  Created by Ernesto Jose Contreras Lopez on 12/21/20.
//

import UIKit

class EmptyViewController: UIViewController {
    
    lazy var emptyView: UIView? = {
        
        let view = UIView()
        view.backgroundColor = Colors.mainWhite
        view.addSubview(emptyLabel)
        emptyLabel.center(inView: view)
        return view
    }()
    
    let emptyLabel: UILabel = {
       
        let label = UILabel()
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.translatesAutoresizingMaskIntoConstraints             = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = .white
        label.textColor = Colors.mainBlack
        label.text = "We're sorry, couldn't get the data correctly. Please reload the app."
        label.font = UIFont.systemFont(ofSize: 36, weight: .thin)
        return label
    }()
}
