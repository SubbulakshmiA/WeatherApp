//
//  ToDoViewController.swift
//  WeatherApp
//
//  Created by user248645 on 10/12/23.
//

import Foundation

import UIKit
import CoreData


class ToDoViewController : UIViewController, UISearchControllerDelegate
{
    
    @IBOutlet weak var myStackView: UIStackView!
    
    @IBOutlet weak var cancelBtn: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var todoTextFld: UITextField!
    
//     var thisCity :  City
    lazy var xactivityList : [Todo]? = [Todo]()  {
        didSet {// there is a better
            tableView.reloadData()
        }
    }
    var thisCity : City? = nil {
        didSet{
            
          
        }
    }
    init?(coder:NSCoder, city : City){
        self.thisCity = city
        super.init(coder: coder)
       }

    required init?(coder: NSCoder) {
        //        fatalError("init(coder:) has not been implemented")
        super.init(coder: coder)
    }
    
    lazy var newItem = [NSManagedObject?]()
    lazy var populateTableController = self.storyboard?.instantiateViewController(withIdentifier: "populateTv") as? PopulateTableViewController
    lazy var searchController = UISearchController(searchResultsController: populateTableController)
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    var cityName : String? = ""
    @IBOutlet weak var saveCity: UIBarButtonItem!
    @IBOutlet weak var mySearch: UISearchBar!
    
    let citiesURL = "http://gd.geobytes.com/AutoCompleteCity?q=Tor&callback=?"
    
    
//    @IBAction func cancelBtnPressed(_ sender: UIBarButtonItem) {
//        print("cancel barbtn pressed in todo")
//        performSegue(withIdentifier: "Cancel", sender: UIBarButtonItem().self)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if let thisCity = thisCity{
            myStackView.isHidden = false
            xactivityList = thisCity.activities?.allObjects as? [Todo]
            title = thisCity.cityName
            // print(thisCity?.activities?.count)
        }else{
            navigationItem.searchController = searchController
            searchController.searchResultsUpdater = self
            populateTableController?.delegate = self
            
        }
    }
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // check safely with guard that your save button is the sender and you can use it
//        // if not print message
//        guard let uiBarButtonItem = sender as? UIBarButtonItem else {
//          print("There is no UIBarButtonItem sender")
//          return
//        }
//
//        // check if you selected the save button
//        if cancelBtn == uiBarButtonItem {
//          print("cancel button selected")
//        }
//      }
//    @IBAction func barItemTapped(_ sender: UIBarButtonItem) {
//        print("BarButton item tapped")
//        // Your action logic
//    }

    
//        navigationItem.searchController = searchController
//        searchController.searchResultsUpdater = self
//        populateTableController?.delegate = self
//        myStackView.isHidden = true
       
//        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveBtnClicked(_:)))
//        navigationItem.rightBarButtonItem = saveButton
   
        
//    }
//    @objc func saveBtnClicked(_ button:UIBarButtonItem!){
//        print("Done clicked")
//
//        if thisCity ==  nil{
//            thisCity = City(context: delegate.persistentContainer.viewContext)
//        }
//        delegate.saveContext()
    
//
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "cancel"{
//            print("cancel btn pressed")
//
//                   for item in newItem {
//                       delegate.persistentContainer.viewContext.delete(item!)
//                   }
//
//        }
//    }
   
    
    
    
    func callingApi(){
        let searchText = searchController.searchBar.text ?? ""
        let citiesURL = "http://gd.geobytes.com/AutoCompleteCity?q=\(searchText)&callback=?"
        Service.shared.getDataFrom(urlStr: citiesURL)
        {
            result   in
            switch result {
            case .failure(let err): print("eror: \(err)")
            case .success( let xdata) :
                print(xdata)
                // converting data to JSON String
                if let jsonString = String(data : xdata , encoding: .utf8){
                   // print("jsonString \(jsonString)")
                    // cleaning JSON String

                    let cleanedJsonString = jsonString.replacingOccurrences(of: "?", with: "").replacingOccurrences(of: "(", with: "").replacingOccurrences(of: ")", with: "").replacingOccurrences(of: ";", with: "")

                    if let cleanedData = cleanedJsonString.data(using: .utf8){
                    //    print("cleanedData \(cleanedData)")
                        // decoding and parsing to City object
                        let resultSet = try? JSONDecoder().decode([String].self, from: cleanedData )

                        if let results = resultSet {
                            DispatchQueue.main.async {
                                var cityNames : [String] = []
                                for item in results{
                                   // let city : String = item
                                   // print("city \(city)")
                                   // self.cityNames =
                                let city : [String] = item.components(separatedBy: ",")
                                   // print("cityName \(self.cityNames[0])")
                                   
                                    cityNames.append(city[0])
                                    print("city \( cityNames)")

                                }
                                self.populateTableController?.cityNames = cityNames
                            }
                        }


                    }
                }
                
                
            }
        }

    }
    
    
    
    
    
}

extension ToDoViewController : UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        callingApi()
    }
}
    
extension ToDoViewController : didfinishSearchDelegate {
    func didFinishSearchWith(cityNames: String?) {
        title = cityNames
        self.cityName = cityNames
//        var newCityName = City(context: delegate.persistentContainer.viewContext)
//
//        newCityName.cityName = cityNames
//                    delegate.saveContext()
//
//
//
//        let fetchRequest = City.fetchRequest()//give all the students
//         fetchRequest.predicate = NSPredicate(format: "cityName == %@", "Toronto")
//         if let results = try? delegate.persistentContainer.viewContext.fetch(fetchRequest){
//             if !results.isEmpty {
//                    // The entity has values
//                    print("The entity has values")
//                 for city in results{
//                  print("city from coredata \(city)")
//                 }
//
//                } else {
//                    // The entity is empty
//                    print("The entity is empty")
//                }
//            }
//
           searchController.isActive = false
        if thisCity == nil{
            thisCity = City(context: delegate.persistentContainer.viewContext)
        }
        newItem.append(thisCity)
        thisCity?.cityName = cityName
        myStackView.isHidden = false


    }
    
        
    }
    

