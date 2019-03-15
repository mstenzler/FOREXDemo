//
//  FavoritesViewController.swift
//  FOREXDemo
//
//  Created by Michael Stenzler on 3/15/19.
//  Copyright © 2019 Michael Stenzler. All rights reserved.
//

import UIKit
import Alamofire

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var symbols: [String] = []
    var currencyPairs: [CurrencyPair] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "SymbolDetailTableHeaderView",bundle: nil), forHeaderFooterViewReuseIdentifier: "SymbolDetailTableHeaderView")
        loadCurrencyPairs()
        print("====tableView = ")
        print(tableView)
       
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
        return currencyPairs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCurrencyPairTableViewCell") as! FavoriteCurrencyPairTableViewCell
        print("in cellForRowAt: indexPath.row = \(indexPath.row)\ncell=")
        print(cell)
        let currencyPair = currencyPairs[indexPath.row]
        print("currencyPair = \(currencyPair)")
        cell.symbolLabel.text = currencyPair.symbol
        cell.priceLabel.text = "\(currencyPair.bid)"
        cell.askLabel.text = "\(currencyPair.ask)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            return tableView.dequeueReusableHeaderFooterView(withIdentifier: "SymbolDetailTableHeaderView")!
        default:
            fatalError() //aasked for a section which doesn't have a header
        }
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
