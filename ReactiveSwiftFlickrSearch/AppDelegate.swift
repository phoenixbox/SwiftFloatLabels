//
//  AppDelegate.swift
//  ReactiveSwiftFlickrSearch
//
//  Created by Colin Eberhardt on 06/07/2014.
//  Copyright (c) 2014 Colin Eberhardt. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
  var window: UIWindow?
  
  var navigationController: UINavigationController!

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject : AnyObject]?) -> Bool {
//    navigationController = UINavigationController()
//    navigationController.navigationBar.barTintColor = UIColor.darkGrayColor()
//    navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
//
//    let viewController = FlickrSearchViewController(viewModel: viewModel)
//    navigationController.pushViewController(viewController, animated: false)
//    
//    
//    window = UIWindow(frame: UIScreen.mainScreen().bounds)
//    window!.rootViewController = navigationController
//    window!.makeKeyAndVisible()
//    
    
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];
//    MyViewController *myViewController = [storyboard instantiateViewControllerWithIdentifier:@"MyViewControllerIdentifier"];
//    myViewController.iVarData = myCustomData;
//    [self presentViewController:myViewController animated:YES completion:nil];
    
//    let storyboard = UIStoryboard(name: "Storyboard", bundle: nil)
    let navController = self.window?.rootViewController as! UINavigationController
    let controller:HomeViewController = navController.childViewControllers.first as! HomeViewController
    let viewModelServices = ViewModelServicesImpl(navigationController: navController)
    let viewModel = FlickrSearchViewModel(services: viewModelServices)
    controller.viewModel = viewModel
    
//    self.window?.rootViewController = controller

//    if let controller = storyboard.instantiateInitialViewController() as? HomeViewController {
//    }
    
    return true
  }
}

