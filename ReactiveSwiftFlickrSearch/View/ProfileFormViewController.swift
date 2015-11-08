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
    
    struct ValidationFormat {
        var title:String
        var color:UIColor
    }
    
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
//                return tuple.second["title"] as! String
                return tuple.second
            } else {
                return [
                    "title": self.viewModel.validations["emailText"]!.placeholder,
                    "color": UIColor.orangeColor()
                ]
            }
        }

        combinedTitleSignal.subscribeNext {
            (validation: AnyObject!) -> () in
            let formatter = validation as! Dictionary<String, NSObject>

            self.emailField.title = (formatter["title"] as! String)
            let labelTextField = self.emailField.cell.textField as! JVFloatLabeledTextField
            labelTextField.floatingLabel.textColor = formatter["color"] as! UIColor
            labelTextField.floatingLabelActiveTextColor = (formatter["color"] as! UIColor)
            
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
    
    private func errorsForValidity(valid : AnyObject!, textField: UITextField) -> Dictionary<String, NSObject>! {
        // return onject which color and text can be picked off
        
//        Composed would look up by tag and then key into a validation object to get error message
//        Instead of passing a bool could pass a Validator object?

        if (valid as! Bool) { // success
            return [
                "title": viewModel.validations["emailText"]!.success,
                "color": UIColor.greenColor() 
            ]
        } else { // failure
            let rule = viewModel.validations["emailText"]!.rule as ValidationRulePattern
            return [
                "title": rule.failureError.message,
                "color": UIColor.redColor()
            ]
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