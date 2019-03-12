//
//  ViewController.swift
//  Todoey
//
//  Created by Christoph Griehl on 08.03.19.
//  Copyright © 2019 apparillo. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let itemArray = defaults.array(forKey: "toDoListArray") as? [String] {
            array = itemArray
        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK DataSource Methods here
    
    var array = ["do things", "do more", "relax a little", "push commit on  Github"]
    
    let defaults = UserDefaults.standard
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
    cell.textLabel?.text = array[indexPath.row]
    return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    //MARK Delegate Methods here
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select wurde ausgeführt")
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    //MARK Add-Item-Button Action
    
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Got something to do?", message: "Fill in a new task.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            self.array.append(textfield.text!)
            self.defaults.set(self.array, forKey: "toDoListArray")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create a new task"
            textfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
    
    
}

