//
//  ViewController.swift
//  FOREXDemo
//
//  Created by Michael Stenzler on 3/2/19.
//  Copyright © 2019 Michael Stenzler. All rights reserved.
//

import UIKit
import Alamofire

extension UISearchController {
    var searchBarIsEmpty: Bool {
        return searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return isActive && ( !searchBarIsEmpty )
    }
}
class SymbolTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var doneBarButtonItem: UIBarButtonItem!
    
    var symbols: [String] = []
    var filteredSymbols = [String]()
    var resultSearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsMultipleSelection = true
        
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.placeholder = "Search items"
            controller.hidesNavigationBarDuringPresentation = false
            //controller.searchBar.sizeToFit()
            
            tableView.tableHeaderView = controller.searchBar
            
            return controller
        })()
        
        definesPresentationContext = true
        
        let urlString = "https://forex.1forge.com/1.0.3/symbols?pairs=EURUSD,GBPJPY,AUDUSD&api_key=scKdc5njprJwBjonYn417rDniGrve9aM"
        Alamofire.request(urlString).responseJSON {  response in
            if let responseData = response.data {
                self.symbols = (try? JSONDecoder().decode([String].self, from: responseData)) ?? []
                self.tableView.reloadData()
            }
            print(response)
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( isFiltering() ) {
            return filteredSymbols.count
        } else {
          return symbols.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SymbolTableViewCell")!
        cell.textLabel?.text = isFiltering() ? filteredSymbols[indexPath.row] : symbols[indexPath.row]
        cell.selectionStyle = .none
        let cellIsSelected = tableView.indexPathsForSelectedRows?.contains(indexPath) ?? false
        cell.accessoryType = cellIsSelected ? .checkmark : .none
        return cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredSymbols.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (symbols as NSArray).filtered(using: searchPredicate)
        filteredSymbols = array as! [String]
        
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
   
        switch segue.identifier ?? "" {
        case "SymbolTableViewController_to_SymbolDetailViewController":
            print("=========== SEGUE ========")
            print(segue.destination)
            guard let destination = segue.destination as? SymbolDetailViewController else {
                fatalError() // changed the class fo the destination
            }
            for indexPath in tableView.indexPathsForSelectedRows ?? [] {
                destination.symbols.append(isFiltering() ? filteredSymbols[indexPath.row] : symbols[indexPath.row])
            }
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        enableDoneBarButtonIfNecessary()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .none
        enableDoneBarButtonIfNecessary()
        //tableView.deselectRow(at: indexPath, animated: true)
        //performSegue(withIdentifier: "SymbolTableViewController_to_SymbolDetailViewController", sender: self)
    }
    
    func enableDoneBarButtonIfNecessary() {
        doneBarButtonItem.isEnabled = (tableView.indexPathsForSelectedRows?.count ?? 0) > 0
    }
    
    func searchBarIsEmpty() -> Bool {
        return resultSearchController.searchBar.text?.isEmpty ?? true
    }
    
    func isFiltering() -> Bool {
        return resultSearchController.isActive && ( !searchBarIsEmpty() )
    }
    
}

