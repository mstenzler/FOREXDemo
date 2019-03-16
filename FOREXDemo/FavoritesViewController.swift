//
//  FavoritesViewController.swift
//  FOREXDemo
//
//  Created by Michael Stenzler on 3/15/19.
//  Copyright © 2019 Michael Stenzler. All rights reserved.
//

import UIKit
import Alamofire
import Firebase

class FavoritesViewController: UIViewController, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    lazy var db = Firestore.firestore()
    lazy var document = db.collection("favorites").document("currentUser")
    var symbols: [String] = []
    var favorites: [String] = []
    var currencyPairs: [CurrencyPair] = []
    
    var selectedFavorites: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        //self.clearsSelectionOnViewWillAppear = YES;
//        tableView.indexPathsForSelectedItems?
//            .forEach { self.collectionView.deselectItem(at: $0, animated: false) }
        
        tableView.allowsMultipleSelection = true
        
        document.addSnapshotListener { (snapshot, error) in
            let favoritesData = snapshot?.data() as? [String: Bool] ?? [:]
            var favoriteSymbols: [String] = []
            for(key, value) in favoritesData {
                if value { favoriteSymbols.append(key) }
            }
            
            self.favorites = favoriteSymbols
            self.tableView.reloadData()
        }
        
//        tableView.register(UINib(nibName: "SymbolDetailTableHeaderView",bundle: nil), forHeaderFooterViewReuseIdentifier: "SymbolDetailTableHeaderView")
//        loadCurrencyPairs()
//        print("====tableView = ")
//        print(tableView)
       
        // Do any additional setup after loading the view.
    }
    
    func loadCurrencyPairs() {
        print("============== in loadCurrencyPairs ===============\ntableView = \n")
        print(tableView)
        let currencyPairs = symbols.joined(separator: ",")
        print("currencyPairs = ")
        print(currencyPairs)
        let urlString = "https://forex.1forge.com/1.0.3/quotes?pairs=\(currencyPairs)&api_key=scKdc5njprJwBjonYn417rDniGrve9aM"
        Alamofire.request(urlString).responseJSON {  response in
            if let responseData = response.data {
                print("======= got data ======")
                self.currencyPairs = (try? JSONDecoder().decode([CurrencyPair].self, from: responseData)) ?? []
                print(self.currencyPairs)
                print("response data = ")
                print(responseData)
                print("About to realodData")
                self.tableView?.reloadData()
            }
            //print(response)
        }
       
    }
    
    func setSymbols(_ newSymbols: [String]) {
        print("================= in setSymbols -=============\nSymbols = \n")
        print(newSymbols)
        print("====tableView = ")
        print(tableView)
        symbols = newSymbols
        loadCurrencyPairs()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCurrencyPairTableViewCell")!
        let symbol = favorites[indexPath.row]
        cell.textLabel?.text = symbol
        cell.selectionStyle = .none
        cell.accessoryType = selectedFavorites.contains(symbol) ? .checkmark : .none
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectedFavorites = []
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("========= in viewWillAppear ========")
        if let selectionIndexPaths = tableView.indexPathsForSelectedRows {
            for indexPath in selectionIndexPaths {
                self.tableView.deselectRow(at: indexPath, animated: animated)
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("============== SEQUE =======")
       // print("sequue.indentier = \(segue.identifier)")
        switch segue.identifier ?? "" {
        case "FavoritesViewController_to_SymbolDetailViewController":
            guard let destination = segue.destination as? SymbolDetailViewController else {
                return
            }
            
            let selectedIndexPaths = tableView.indexPathsForSelectedRows ?? []
            var selectedSymbols: [String] = []
            
            for indexPath in selectedIndexPaths {
                selectedSymbols.append(favorites[indexPath.row])
            }
            
            destination.symbols = selectedFavorites
        default:
            assert(false, "You added a segue but didn't impletment prepare for segue")
        }
    }
}

extension FavoritesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        selectedFavorites.append(favorites[indexPath.row])
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = self.tableView.cellForRow(at: indexPath)
        selectedFavorites.removeAll { (element) -> Bool in
            return element == self.favorites[indexPath.row]
        }
        cell?.accessoryType = .none
    }
    
}
