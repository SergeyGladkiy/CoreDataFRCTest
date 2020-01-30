//
//  ListOfUserViewController.swift
//  JuniorExercize
//
//  Created by Serg on 30.12.2019.
//  Copyright © 2019 Sergey Gladkiy. All rights reserved.
//

import UIKit
import CoreData

class ListOfUsersViewController: ParentTableViewController {
    
    var course: Course?
    var onlyOneCheckmark: Bool? = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        let firstNameSortDescriptor = NSSortDescriptor(key: "firstName", ascending: true)
        let lastNameSortDescriptor = NSSortDescriptor(key: "lastName", ascending: true)
        fetchRequest.sortDescriptors = [firstNameSortDescriptor, lastNameSortDescriptor]
        
         let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController as? NSFetchedResultsController<NSFetchRequestResult>
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
             // Replace this implementation with code to handle the error appropriately.
             // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             let nserror = error as NSError
             fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    //MARK: UITableViewDataSource
     override func configureCell(_ cell: UITableViewCell, with object: NSFetchRequestResult) {
         let user = object as! User
        cell.textLabel!.text = user.firstName! + " " + user.lastName!
        cell.detailTextLabel?.text = user.email!
        
        if onlyOneCheckmark != nil && course != nil {
            guard let teacher = course?.teacher else {
                cell.accessoryType = .none
                return
            }
            cell.accessoryType = user === teacher ? .checkmark : .none
            
        } else if onlyOneCheckmark == nil && course != nil {
            guard let students = course?.students else {
                cell.accessoryType = .none
                return
            }
            _ = students.map {
                cell.accessoryType = user === $0 as! User ? .checkmark : .none
            }
        }
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
       // let cell = tableView.cellForRow(at: indexPath)
        
        //if course != nil
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if course != nil && onlyOneCheckmark == false && cell?.accessoryType != .checkmark {
            cell?.accessoryType = .checkmark
            course?.teacher = fetchedResultsController.object(at: indexPath) as? User
            onlyOneCheckmark = true
            return
        } else if course != nil && onlyOneCheckmark == true && cell?.accessoryType == .checkmark {
            cell?.accessoryType = .none
            course?.teacher = nil
            onlyOneCheckmark = false
            return
        } else if course != nil && onlyOneCheckmark == true && cell?.accessoryType != .checkmark {
            return
        }
        
        let user = fetchedResultsController.object(at: indexPath) as! User
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserInfoViewController") as! UserInfoViewController
        vc.user = user
        vc.context = managedObjectContext
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! UserInfoViewController
        vc.context = managedObjectContext
    }
}
