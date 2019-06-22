//
//  LoadingViewController.swift
//  Virtual Tourist
//
//  Created by Mac User on 6/21/19.
//  Copyright © 2019 Me. All rights reserved.
//

import Foundation
import UIKit

class LoadingViewController: UIViewController {
    var loading = UIActivityIndicatorView(style: .whiteLarge)
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.7)
        
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.startAnimating()
        view.addSubview(loading)
        
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
