//
//  ProfileFormViewController.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Shane Rogers on 11/6/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

import UIKit
import Eureka
//MARK: Emoji

typealias Emoji = String
let 👦🏼 = "👦🏼", 🍐 = "🍐", 💁🏻 = "💁🏻", 🐗 = "🐗", 🐼 = "🐼", 🐻 = "🐻", 🐖 = "🐖", 🐡 = "🐡"

//Mark: RowsExampleViewController

class ProfileFormViewController: FormViewController {
    var viewModel: FlickrSearchViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Form creation")
        
        form +++ Section("Custom cells")
            +++ PhoneRow("Phone"){ $0.title = self.viewModel.searchText}
            <<< IntRow("IntRow"){ $0.title = "Int"; $0.value = 5 }
            +++ Section("Email Section")
            <<< EmailRow("EmailRow") { $0.title = "Email" }
    }
    
    
}