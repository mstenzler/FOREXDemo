//
//  MyTabBarController.swift
//  FOREXDemo
//
//  Created by Michael Stenzler on 3/15/19.
//  Copyright © 2019 Michael Stenzler. All rights reserved.
//

import UIKit

class MyTabBarController: UITabBarController, FavoriteArrayDelegaate {
    
    var favoritesViewController: FavoritesViewController?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        print("=====\n=====\n=====\n====\n===\n====\n======\n===\n====\n======\n")
        print("======== in MyTabBarController viewdidLoad ==============\n ViewControllers = ")
        print(viewControllers)
        
        if let firstNavigationController = self.viewControllers?.first as? UINavigationController {
            print("Got first navication controller: \(firstNavigationController)")
            if let firstViewController = firstNavigationController.viewControllers.first as? SymbolTableViewController {
                print("\n\n================ Got firstViewController\n")
                print(firstViewController)
                firstViewController.favoriteDataDelegate = self
            }
        }
        
        if let viewControllers = self.viewControllers, viewControllers.count > 1,
            let favoritesNavigationController = self.viewControllers?[1] as? UINavigationController {
                print("Got favorite navigation controller")
                if let favoritesViewController = favoritesNavigationController.viewControllers.first as? FavoritesViewController {
                    print("\n\n===================== FavoritesViewController = ")
                    print(favoritesViewController)
                    self.favoritesViewController = favoritesViewController
            }
        } else {
            print("================== COUULD NOT GET FAVOITES VIEW CONTROLLER =================")
        }

        // Do any additional setup after loading the view.
    }
    
    func favoritesDidChange(_ favorites: [String : Bool]?) {
        print("====== in favoritesDidChange ==============")
        var myFavorites = [String]()
        for (key, value) in favorites ?? [:] {
            print("key = \(key) value = \(value)")
            if value == true {
                print("\(value) is true!")
                myFavorites.append(key)
            }
        }
        print("myFavorites now = \(myFavorites)")
        favoritesViewController!.setSymbols(myFavorites)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
