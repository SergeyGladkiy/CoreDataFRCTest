//
//  UserInfoViewController.swift
//  JuniorExercize
//
//  Created by Serg on 31.12.2019.
//  Copyright © 2019 Sergey Gladkiy. All rights reserved.
//

import UIKit
import CoreData

class UserInfoViewController: UITableViewController {
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    var user: User!
    weak var context: NSManagedObjectContext!
    private var infoAttributes = ["FirstName", "LastName", "Email"]
    private var arrayFields = [UITextField]()
    
    private var estimatedHeight: CGFloat = 50
    private let reusableIdentifier = "InfoCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingTableView()
        self.navigationItem.title = "Set user's info"
    }
    
    private func settingTableView() {
        //MARK: make xib cell otherwise label and textField are nil (reason is prototipe cell in storyboard)
        let nibCell = UINib(nibName: "InformingCell", bundle: Bundle(for: InformingCell.self))
        tableView?.register(nibCell, forCellReuseIdentifier: reusableIdentifier)
        
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = estimatedHeight
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        tableView.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkEmptyFields()
    }
    
    @IBAction func saveUserInfo(_ sender: UIBarButtonItem) {
        if self.user == nil {
            //!!!!! arc
            let user = User(context: self.context)
            self.user = user
            setParameters(user: self.user, sender: sender)
        } else {
            setParameters(user: self.user, sender: sender)
        }
    }
    
    private func setParameters(user: User, sender: UIBarButtonItem) {
        user.firstName = arrayFields[0].text
        user.lastName = arrayFields[1].text
        user.email = arrayFields[2].text
        
        //let context = self.context
        do {
            try self.context.save()
            sender.isEnabled = false
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    @objc func hideKeyboard(_ gesture: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    private func checkEmptyFields() {
        var attributes = Set<String>()
        for field in arrayFields {
            if field.text == "" {
                saveButton.isEnabled = false
                break
            } else {
                //MARK: delete all " "
                field.text = field.text?.trimmingCharacters(in: .whitespaces)
                attributes.insert(field.text!)
                saveButton.isEnabled = true
            }
        }
        
        guard attributes.count != 0 else { return }
        guard let user = self.user else { return }
        let userInformation: Set<String> = [user.firstName!, user.lastName!, user.email!]
        let result = !userInformation.isSuperset(of: attributes)
        //print("result \(result)")
        saveButton.isEnabled = result
    }
    
    
    
    
    // MARK: - Table view delegate
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return infoAttributes.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    

    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return infoAttributes[section]
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusableIdentifier, for: indexPath) as! InformingCell
        cell.infoTextField.delegate = self
        cell.infoLabel.isHidden = true
        self.arrayFields.append(cell.infoTextField)
        
        guard let user = self.user else { return cell }
        let array = [user.firstName, user.lastName, user.email]
        cell.infoTextField.text = array[indexPath.section]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UserInfoViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkEmptyFields()
    }
}


