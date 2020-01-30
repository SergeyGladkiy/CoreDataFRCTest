//
//  CourseInfoViewController.swift
//  JuniorExercize
//
//  Created by Serg on 05.01.2020.
//  Copyright © 2020 Sergey Gladkiy. All rights reserved.
//

import UIKit
import CoreData
class CourseInfoViewController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @objc var course: Course?
    
    weak var context: NSManagedObjectContext!
    private var infoAttributes: [InterfaceSourceInfo] = [FieldsOfCourse(sectionName: "Information of the course", labelNameOfRows: ["Name", "Sector", "Subject", "Teacher"]), StudentsOfCourse(sectionName: "Students of the course", labelNameOfRows: nil)]
    private var arrayFields = [UITextField]()
    
    private var estimatedHeight: CGFloat = 50
    private let reusableIdentifier = "InfoCell"
    
    var teacherObservation: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView()
        self.navigationItem.title = "Set course's info"
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkEmptyFields()
    }
    
    private func settingTableView() {
        let nibCell = UINib(nibName: "InformingCell", bundle: Bundle(for: InformingCell.self))
        tableView?.register(nibCell, forCellReuseIdentifier: reusableIdentifier)
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = estimatedHeight
        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
//        _ = arrayFields.map {
//            if $0 != arrayFields.last {
//                $0.addGestureRecognizer(tapGesture)
//            }
//        }
    }
    
    @objc func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        gesture.view?.endEditing(true)
    }

    @IBAction func saveCourseInfo(_ sender: UIBarButtonItem) {
        if self.course == nil {
            let course = Course(context: self.context)
            self.course = course
            setParameters(course: self.course!, sender: sender)
        } else {
            setParameters(course: self.course!, sender: sender)
        }
    }
    
    private func setParameters(course: Course, sender: UIBarButtonItem) {
        course.name = arrayFields[0].text
        course.sector = arrayFields[1].text
        course.subject = arrayFields[2].text
        
        do {
            try self.context.save()
            sender.isEnabled = false
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func checkEmptyFields() {
        var attributes = Set<String>()
        for field in arrayFields[0..<arrayFields.count - 1] {
            if field.text == "" {
                saveButton.isEnabled = false
                break
            } else {
                //MARK: delete all " "
                //field.text = field.text?.trimmingCharacters(in: .whitespaces)
                attributes.insert(field.text!)
                saveButton.isEnabled = true
            }
        }
        
        guard attributes.count != 0 else { return }
        guard let course = self.course else { return }
        let userInformation: Set<String> = [course.name!, course.sector!, course.subject!]
        let result = !userInformation.isSuperset(of: attributes)
        print("result \(result)")
        saveButton.isEnabled = result
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return infoAttributes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section1 = course != nil ? course!.students!.count + 1 : 1
        return section == 0 ? infoAttributes[0].labelNameOfRows.count : section1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return infoAttributes[section].sectionName
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! InformingCell
        
        if indexPath.section == 0 {
            cell.infoLabel.text = infoAttributes[0].labelNameOfRows[indexPath.row]
            self.arrayFields.append(cell.infoTextField)
            cell.infoTextField.delegate = self
            
            guard let course = self.course else {
                if indexPath.row == 3 {
                    cell.infoTextField.text = "No information"
                    cell.infoTextField.isEnabled = false
                    cell.accessoryType = .detailButton
                    return cell
                }
                return cell
            }
            let infoTeacher = course.teacher != nil ? course.teacher!.firstName! + " " + course.teacher!.lastName! : "No information"
            let arrayInfo = [course.name, course.sector, course.subject, infoTeacher]
            cell.infoTextField.text = arrayInfo[indexPath.row]
            if indexPath.row == 3 {
                cell.accessoryType = .disclosureIndicator
                cell.infoTextField.isEnabled = false
            }
            
        } else if indexPath.section == 1 {
            if let textField = cell.infoTextField {
                textField.removeFromSuperview()
            }
            cell.infoLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            
            if indexPath.row == 0 {
                cell.infoLabel.text = "Add a student"
                cell.infoLabel.textColor = .blue
                return cell
            }
            
            guard let arrayStudents = course?.students else { return cell }
            let student = arrayStudents[indexPath.row] as! User
            cell.infoLabel.text = student.firstName! + student.lastName!
        }

        return cell
    }
    

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == 0 {
            return false
        }

        return indexPath.row != 0 ? true : false
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            course?.removeFromStudents(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
//            do {
//                try context.save()
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            } catch let error as NSError {
//                 print("Error: \(error), userInfo \(error.userInfo)")
//            }
        }
    }
    
    // MARK: - Table view delegate
    // MARK: for ONLY Detail button
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("tap")
    }
   
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 && indexPath.row == 3 {
            let vc = storyboard?.instantiateViewController(identifier: "UsersVC") as! ListOfUsersViewController
            self.course = self.course != nil ? self.course : Course(context: self.context)
            vc.course = self.course
            //MARK: KVO
            teacherObservation = vc.course?.observe(\Course.teacher, options: [.new, .old]) { (vc, change) in
                guard let _ = change.newValue else { return }
                self.tableView.reloadData()
            }
            self.navigationController?.pushViewController(vc, animated: true)
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

extension CourseInfoViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkEmptyFields()
    }
}
