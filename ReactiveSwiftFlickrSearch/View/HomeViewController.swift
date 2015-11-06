//
//  HomeViewController.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Shane Rogers on 11/5/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

import Foundation
import UIKit
import Eureka

class HomeViewController: UIViewController {
    var viewModel: FlickrSearchViewModel!
    
    @IBOutlet weak var viewLabel: UILabel!
//    init(viewModel:FlickrSearchViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: "HomeViewController", bundle: nil)
////        super.init(nibName: "FlickrSearchViewController", bundle: nil)
//    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    func bindViewModel() {
        viewLabel.text = self.viewModel!.searchText
    }
}
