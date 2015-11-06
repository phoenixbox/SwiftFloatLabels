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
    
    @IBOutlet weak var formContainer: UIView!
    @IBOutlet weak var viewLabel: UILabel!
    dynamic var profileFormViewController: ProfileFormViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier! == "profile_form_embed") {
          print("Prepare for embed segue")
//            Expect that sequential operations
            
          profileFormViewController = segue.destinationViewController as! ProfileFormViewController
          profileFormViewController.viewModel = viewModel
        }
    }
    
    func bindViewModel() {
        viewLabel.text = self.viewModel!.searchText
        
        
    }
}
