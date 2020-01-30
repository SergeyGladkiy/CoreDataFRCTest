//
//  CourcesViewController.swift
//  JuniorExercize
//
//  Created by Serg on 04.01.2020.
//  Copyright © 2020 Sergey Gladkiy. All rights reserved.
//

import UIKit
import CoreData

class CoursesViewController: ParentTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Course> = Course.fetchRequest()
        fetchRequest.fetchBatchSize = 20
        
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let aFetchResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        aFetchResultsController.delegate = self
        
        _fetchedResultsController = aFetchResultsController as? NSFetchedResultsController<NSFetchRequestResult>
        
        do {
            try _fetchedResultsController?.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    // MARK: - Table view data source

    override func configureCell(_ cell: UITableViewCell, with object: NSFetchRequestResult) {
        let course = object as! Course
        cell.textLabel?.text = course.name != nil ? course.name : "The name is not selected" //+ " предмет " + course.subject! + " отрасль " + course.sector!
        cell.detailTextLabel?.text = String(course.students?.count ?? 0)
     }
    
     //MARK: UITableViewDelegate
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let course = fetchedResultsController.object(at: indexPath) as! Course
         
        let vc = storyboard?.instantiateViewController(withIdentifier: "CourseInfoViewController") as! CourseInfoViewController
        vc.course = course
        vc.context = managedObjectContext
        self.navigationController?.pushViewController(vc, animated: true)
    }


    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! CourseInfoViewController
        vc.context = managedObjectContext
    }

}
