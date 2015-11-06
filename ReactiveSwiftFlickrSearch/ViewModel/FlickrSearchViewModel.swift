//
//  FlickrSearchViewModel.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation
import Validator

// The top-level ViewModel, exposes an interface that allows you
// to search Flickr via a search string It also displays the 
// history of recent searches
class FlickrSearchViewModel : NSObject {
  
  //MARK: Properties
  
  dynamic var searchText = "Banana"
  dynamic var phoneNumber = ""
  dynamic var previousSearches: [PreviousSearchViewModel]
  var executeSearch: RACCommand?
  let title = "Flickr Search"
  var previousSearchSelected: RACCommand!
  var connectionErrors: RACSignal!
  var searchTextSignal: RACSignal!
  var phoneNumberSignal: RACSignal!
  var enabledSearch: RACSignal!
//  var validationErrors: Dictionary<String, AnyObject>
  var validators: [String: ValidationRulePattern] = [
    "searchText": ValidationRulePattern(pattern: .EmailAddress, failureError: ValidationError(message: "😫")),
    "phoneNumber": ValidationRulePattern(pattern: "^\\d{10}$", failureError: ValidationError(message: "😫"))
    ]
  
  private let services: ViewModelServices
  
  //MARK: Public APIprintln
  
  init(services: ViewModelServices) {
    
    self.services = services
    previousSearches = []
    
    super.init()
    
    // Observer receives the pass from the View
    // searchTextField.rac_textSignal() ~> RAC(viewModel, "searchText")
    // TODO:
    // Add two fields and reduce signal - yes
    // Implement Validator - yes
    // Implement Eureka form builder -
    // Implement conditional label states based on validations with RAC -
    // Sync ViewModel and Model? - Wrap an async call to server with signal
    // Bind & reduce the execution of that call to a button 
    // On success - find and update the View's ViewModel which contains the model/collection returned from the API based on the response
    searchTextSignal = signalForField("searchText")
    phoneNumberSignal = signalForField("phoneNumber")
    enabledSearch = RACSignal.combineLatest([searchTextSignal, phoneNumberSignal]).map {
        let tuple = $0 as! RACTuple
        let bools = tuple.allObjects() as! [Bool]
        let result: Bool = bools.reduce(true) { $0 && $1 }
        return result
    }
    executeSearch = RACCommand(enabled: enabledSearch) {
      (any:AnyObject!) -> RACSignal in
      return self.executeSearchSignal()
    }
    
    connectionErrors = executeSearch!.errors
    previousSearchSelected = RACCommand() {
      (any:AnyObject!) -> RACSignal in
      let previousSearch = any as! PreviousSearchViewModel
      self.searchText = previousSearch.searchString
      return self.executeSearchSignal()
    }
  }
  
  //MARK: Private methods
    
    private func signalForField(fieldName: String) -> RACSignal {
       return RACObserve(self, keyPath: fieldName).mapAs {
            (text: NSString) -> NSNumber in
            let value = text as String
            
            if let _ = self.validators[fieldName] as ValidationRulePattern! {
                let result = value.validate(rule: self.validators[fieldName]! as
                    ValidationRulePattern)
                return result.isValid
            } else {
                return false
            }
            
        }.distinctUntilChanged();
    }
  
  private func executeSearchSignal() -> RACSignal {
    return services.flickrSearchService.flickrSearchSignal(searchText).doNextAs {
      (results: FlickrSearchResults) -> () in
      let viewModel = SearchResultsViewModel(services: self.services, searchResults: results)
      self.services.pushViewModel(viewModel)
      self.addToSearchHistory(results)
    }
  }
  
  private func addToSearchHistory(result: FlickrSearchResults) {
    let matches = previousSearches.filter { $0.searchString == self.searchText }
    
    var previousSearchesUpdated = previousSearches

    if matches.count > 0 {
      let match = matches[0]
      var withoutMatch = previousSearchesUpdated.filter { $0.searchString != self.searchText }
      withoutMatch.insert(match, atIndex: 0)
      previousSearchesUpdated = withoutMatch
    } else {
      let previousSearch = PreviousSearchViewModel(searchString: searchText, totalResults: result.totalResults, thumbnail: result.photos[0].url)
      previousSearchesUpdated.insert(previousSearch, atIndex: 0)
    }
    
    if (previousSearchesUpdated.count > 10) {
      previousSearchesUpdated.removeLast()
    }
    
    previousSearches = previousSearchesUpdated
  }

}

// Scratch
//if let presence = self.validationConfig["email"]!["presence"] {
//    print("regex is \(presence)")
//}
//let regex = self.validationConfig["email"]!["regex"]
//print("regex is \(regex)")