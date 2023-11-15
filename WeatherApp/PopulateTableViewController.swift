//
//  PopulateTableViewController.swift
//  WeatherApp
//
//  Created by user248645 on 10/12/23.
//

import Foundation

import UIKit
protocol didfinishSearchDelegate : AnyObject {
    func didFinishSearchWith(cityNames : String?)
    
}

class  PopulateTableViewController : UITableViewController
{
    weak var delegate : didfinishSearchDelegate?
    
    var cityNames : [String]? = nil {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
    //    mySearch.text = searchText
      //  searchBar.delegate = self
        
      //  searchBar.text = searchTextValue
      //  searchBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44)
      //  self.view.addSubview(searchBar)
        //callingApi()
        tableView.isScrollEnabled = true
    }

    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
            // Called when the user begins editing the search bar
        }

         
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Called when the text in the search bar changes
        // You can use this to filter data or perform search operations
        //            searchBar.text = searchTextValue
        if searchText.count >= 3 {
            
           // print("\(searchText)")
          //  searchTextValue = searchText
            //callingApi()
        }
    }

    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cityNames?.count ?? 0
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        //let data = serverResponse.data as! [User]
        //collectionData = Array(data.prefix(upTo: 10))
        //tableData =  Array(data.suffix(from: 11))
       
        cell.textLabel?.text = self.cityNames?[indexPath.row]
        
        //Array(cityNames[indexPath].prefix(upTo: 10))
        
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.didFinishSearchWith(cityNames: cityNames?[indexPath.row])
        
    }

   
    
    
    
}
