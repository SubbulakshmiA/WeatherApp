//
//  CitiesTableViewController.swift
//  WeatherApp
//
//  Created by user248645 on 10/12/23.
//

import Foundation

import UIKit
import CoreData


class CitiesTableViewController : UITableViewController //lerDelegate
{
    
    @IBOutlet weak var mySearch: UISearchBar!
    
    
    @IBOutlet var myTableView: UITableView!
    
    let delegate = UIApplication.shared.delegate as! AppDelegate
    
    
    lazy var myFetchResultController : NSFetchedResultsController <City> = {
        
        
        
        let fetch :  NSFetchRequest<City> =  City.fetchRequest()
        
        fetch.sortDescriptors = [NSSortDescriptor(key: "cityname", ascending: true) ]
        
        let ftc = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: (delegate.persistentContainer.viewContext), sectionNameKeyPath: nil, cacheName: nil)
            
        ftc.delegate = self
        
        return ftc
             
        
        
    }( )
    
    lazy var city : City = City()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        
        //        do{
        //
        //        try
        //            myFetchResultController.performFetch()
        //
        //        } catch { print("Error performing fetch: \(error)") }
        //
        
        
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "cellSegue" {
            if let selected = tableView.indexPathForSelectedRow{
                let object = myFetchResultController.object(at: selected)
                if let destVC = segue.destination as? UINavigationController,
                   let targetController = destVC.topViewController as? ToDoViewController {
                    targetController.thisCity = object
                }
            }
            ////
            //           }else if segue.identifier == "todoVc" {
            //               if let selected = tableView.indexPathForSelectedRow{
            //                   if let destVC = segue.destination as? UINavigationController,
            //                       let targetController = destVC.topViewController as? ToDoViewController {
            //                       targetController.thisCity = nil
            //                   }
            //               }
            //
            //
            //              }
        }
    }
        
    @IBAction func unwindToCitiesVC(segue: UIStoryboardSegue) {
//        guard segue.identifier == "save" else {return}
//        let sourceViewController = segue.source as! ToDoViewController
//        if let _ = sourceViewController.thisCity{
//
//            do{
//              try  delegate.persistentContainer.viewContext.save()
//            }catch{
//                print("unwind segue")
//            }
//        }
////         Use data from the view controller which initiated the unwind segue
        print("unwind segue")
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        if let viewControllers = navigationController?.viewControllers {
//            for viewController in viewControllers {
//                print(viewController)
//                print("citytableview")
//                do{
//                try
//                    myFetchResultController.performFetch()
//                } catch { print("Error performing fetch: \(error)") }
//            }
//        }
//        self.tableView.reloadData()
//    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return myFetchResultController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return myFetchResultController.sections?[section].numberOfObjects ?? 0
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        let object = myFetchResultController.object(at: indexPath)
        cell.textLabel?.text = object.cityName
        return cell
        
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

    extension CitiesTableViewController : UISearchBarDelegate{
       
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    
            var predicate : NSPredicate? = nil
            if !searchText.isEmpty
            {
                predicate = NSPredicate(format: "cityname CONTAINS[c]  %@ ", searchText)
            }
            
            myFetchResultController.fetchRequest.predicate = predicate
            
            try? myFetchResultController.performFetch()
            
            tableView.reloadData()
            
            
        }
        
        
    }
    
extension CitiesTableViewController : NSFetchedResultsControllerDelegate{
    
    // Section update(s)
    func controller(_
        controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .automatic)
        default: break
        }
    }
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ){
        switch type {
        case .insert:
            if let index = newIndexPath {
                tableView.insertRows(at: [index], with: .automatic)
            }
        case .delete:
            if let index = indexPath {
                tableView.deleteRows(at: [index], with: .automatic)
            }
        case .update:
            if let index = indexPath {
                tableView.reloadRows(at: [index], with: .automatic)
            }
        case .move:
            if let deleteIndex = indexPath, let insertIndex = newIndexPath {
                tableView.deleteRows(at: [deleteIndex], with: .automatic)
                tableView.insertRows(at: [insertIndex], with: .automatic)
            }
        default:
            print("Row update error")
        }
    
    }
    
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
}



