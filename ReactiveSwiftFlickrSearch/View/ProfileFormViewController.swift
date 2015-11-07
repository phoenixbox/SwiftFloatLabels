//
//  ProfileFormViewController.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Shane Rogers on 11/6/15.
//  Copyright © 2015 Colin Eberhardt. All rights reserved.
//

import UIKit
import Eureka
import JVFloatLabeledTextField
import Validator
//MARK: Emoji

typealias Emoji = String
let 👦🏼 = "👦🏼", 🍐 = "🍐", 💁🏻 = "💁🏻", 🐗 = "🐗", 🐼 = "🐼", 🐻 = "🐻", 🐖 = "🐖", 🐡 = "🐡"

//Mark: RowsExampleViewController

class ProfileFormViewController: FormViewController {
    var viewModel: FlickrSearchViewModel!
    var emailField: FloatFieldRow <String, EmailFloatLabelCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Form creation")
        self.createForm()
        self.bindFields()
    }
    
    private func bindFields() {
        self.bindEmailField()
    }
    
    private func bindEmailField() {
        let labelTextField = self.emailField.cell.textField as! JVFloatLabeledTextField
        
        let contentSignal = labelTextField.rac_textSignal()
        // Passive signal - triggers ViewModel observer validation observer
        labelTextField.rac_textSignal() ~> RAC(viewModel, "emailText")

        let validEmailSignal = textFieldErroMessageWithSignal(viewModel.emailSignal, textField: labelTextField)
        let combinedTitleSignal = RACSignal.combineLatest([contentSignal, validEmailSignal]).map {
            let tuple = $0 as! RACTuple
            let currentText = tuple.first as! String
            
            if (currentText.characters.count > 0) {
                return tuple.second as! String
            } else {
                return self.viewModel.validations["emailText"]!.placeholder
            }
        }
        // Restart: make the form values use a configuration object
        combinedTitleSignal.subscribeNextAs {
            (title: String) -> () in
            print("\(title)")
            self.emailField.title = title
            self.emailField.updateCell()
        }
    }
    
    private func textFieldErroMessageWithSignal(signal:RACSignal, textField:UITextField) -> RACSignal {
        return signal.filter({ (_) -> Bool in
            return self.isValidTextField(textField)
        }).throttle(0.5, valuesPassingTest: { (object) -> Bool in
            return (object as? Bool) == false
        }).map({ [unowned self] (object) -> AnyObject in
            return self.errorsForValidity(object, textField: textField)
        })
    }
    
    private func isValidTextField(textField: UITextField) -> Bool {
        return textField.text!.characters.count > 0 && textField.isFirstResponder()
    }
    
    private func errorsForValidity(valid : AnyObject!, textField: UITextField) -> String! {
//        Composed would look up by tag and then key into a validation object to get error message
//        Instead of passing a bool could pass a Validator object?

        if (valid as! Bool) {
            return viewModel.validations["emailText"]!.success
        } else {
            let rule = viewModel.validations["emailText"]!.rule
            return rule.failureError.message
        }
    }
    
    private func createForm() {
        form +++ Section("Custom cells")
            +++ PhoneRow("Phone"){ $0.title = self.viewModel.searchText}
            <<< IntRow("IntRow"){ $0.title = "Int"; $0.value = 5 }
            +++ Section("Email Section")
            <<< EmailFloatLabelRow("EmailRow") {
                $0.tag = "email"
                $0.title = "Email"
                self.emailField = $0
            }
//            <<< TextFloatLabelRow() {
//                $0.title = "Float Label Row, type something to see.."
//            }
//            <<< IntFloatLabelRow() {
//                $0.title = "Add an int"
//            }
//            <<< DecimalFloatLabelRow() {
//                $0.title = "Add a decimal"
//            }
//            <<< URLFloatLabelRow() {
//                $0.title = "Add a url"
//            }
//            <<< TwitterFloatLabelRow() {
//                $0.title = "Add a twitter"
//            }
//            <<< AccountFloatLabelRow() {
//                $0.title = "Add a account"
//            }
//            <<< NameFloatLabelRow() {
//                $0.title = "Add a name"
//            }
//            <<< PasswordFloatLabelRow() {
//                $0.title = "Add a password"
//            }
//            <<< EmailFloatLabelRow() {
//                $0.tag = "email"
//                $0.title = "Add an email"
//        }
    }
    
    
}