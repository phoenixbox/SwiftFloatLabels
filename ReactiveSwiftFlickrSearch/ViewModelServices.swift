//
//  ViewModelServicesImpl.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 15/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import Foundation

// provides common services to view models
protocol ViewModelAPI {
    func pushViewModel(viewModel:AnyObject)
}

class ViewModelServices: ViewModelAPI {
  
  private let navigationController: UINavigationController

  
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  func pushViewModel(viewModel:AnyObject) {
    if let searchResultsViewModel = viewModel as? SearchResultsViewModel {
      self.navigationController.pushViewController(SearchResultsViewController(viewModel: searchResultsViewModel), animated: true)
    }
  }
}