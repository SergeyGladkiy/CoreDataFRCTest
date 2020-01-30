//
//  ParentTableViewController.swift
//  JuniorExercize
//
//  Created by Serg on 02.01.2020.
//  Copyright © 2020 Sergey Gladkiy. All rights reserved.
//

import UIKit
import CoreData

class ParentTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    private let reuseIdentifier = "Cell"
    
    var managedObjectContext: NSManagedObjectContext {
        let context = DataManager.shared.persistentContainer.viewContext
        return context
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return fetchedResultsController.sections?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel?.font = UIFont.init(name: "Helvetica Neue", size: 21)
        cell.detailTextLabel?.font = UIFont.init(name: "Helvetica Neue", size: 21)
        cell.accessoryType = .disclosureIndicator
        
        let object = fetchedResultsController.object(at: indexPath)
        configureCell(cell, with: object)
        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath) as! NSManagedObject)
          
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }    
    }

    func configureCell(_ cell: UITableViewCell, with object: NSFetchRequestResult) {
         fatalError("Not use ParentTableViewController in role object, inherit from it and implement this method in descendant")
     }
    
    // MARK: - Fetched results controller
    var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        fatalError("Not use ParentTableViewController in role object, inherit from it and implement this method in descendant")
    }
    
    var _fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = nil

    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, with: anObject as! NSFetchRequestResult)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, with: anObject as! NSFetchRequestResult)
        default:
            return
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
}
