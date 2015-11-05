//
//  FlickrSearchViewController.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

class FlickrSearchViewController: UIViewController {

  @IBOutlet var searchTextField: UITextField!
  @IBOutlet weak var phoneNumberField: UITextField!
  @IBOutlet var searchButton: UIButton!
  @IBOutlet var searchHistoryTable: UITableView!
  @IBOutlet var loadingIndicator: UIActivityIndicatorView!
  
  private let viewModel: FlickrSearchViewModel
  private var bindingHelper: TableViewBindingHelper!
  
  required init?(coder: NSCoder) {
    fatalError("NSCoding not supported")
  }
  
  init(viewModel:FlickrSearchViewModel) {
    self.viewModel = viewModel
    
    super.init(nibName: "FlickrSearchViewController", bundle: nil)
    
    edgesForExtendedLayout = .None
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindViewModel()
  }
  
    private func bindViewModel() {
        title = viewModel.title
        searchButton.rac_command = viewModel.executeSearch
        
        self.bindSearchField()
        self.bindPhoneNumberField()
        self.bindActivityIndicators()
        self.bindTableView()
        self.bindKeyboardMgmt()
    }
    
    private func bindKeyboardMgmt() {
        func hideKeyboard(any: AnyObject!) {
            self.searchTextField.resignFirstResponder()
        }
        viewModel.executeSearch!.executionSignals.subscribeNext(hideKeyboard)
    }
    
    private func bindTableView() {
        bindingHelper = TableViewBindingHelper(tableView: searchHistoryTable, sourceSignal: RACObserve(viewModel, keyPath: "previousSearches"), nibName: "RecentSearchItemTableViewCell", selectionCommand: viewModel.previousSearchSelected)

    }
    
    private func bindActivityIndicators() {
        viewModel.executeSearch!.executing.not() ~> RAC(loadingIndicator, "hidden")
        viewModel.executeSearch!.executing ~> RAC(UIApplication.sharedApplication(), "networkActivityIndicatorVisible")
    }
    
    private func bindNetworkErrorHandler() {
        viewModel.connectionErrors.subscribeNextAs {
            (error: NSError) -> () in
            let alert = UIAlertView(title: "Connection Error", message: "There was a problem reaching Flickr", delegate: nil, cancelButtonTitle: "OK")
            alert.show()
        }
    }
    
    private func bindSearchField() {
        searchTextField.rac_textSignal() ~> RAC(viewModel, "searchText")
        textFieldColorValidationWithSignal(viewModel.searchTextSignal, textField: searchTextField) ~> RAC(searchTextField, "backgroundColor")
    }
    
    private func bindPhoneNumberField() {
        phoneNumberField.rac_textSignal() ~> RAC(viewModel, "phoneNumber")
    }

//    Works!! :) :) :)
    private func textFieldColorValidationWithSignal(signal:RACSignal, textField:UITextField) -> RACSignal {
        return signal.filter({ (_) -> Bool in
            // Make sure we have input and we're still the active textField
            return textField.text!.characters.count > 0 && textField.isFirstResponder()
        }).throttle(0.5, valuesPassingTest: { (object) -> Bool in
            // Wait for 0.5 seconds before continuing and showing the coloured background feedback
            // If a `next` is received, and then another `next` is received before
            // `interval` seconds have passed, the coloured background won't appear yet
            return (object as? Bool) == false
        }).map({ [unowned self] (object) in
            self.colorForValidity(object)
        })
    }
    private func colorForValidity(valid : AnyObject!) -> UIColor! {
        return (valid as? Bool) == false ? UIColor.redColor() : UIColor.clearColor()
    }

}










