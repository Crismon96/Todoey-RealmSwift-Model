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
        print(dataFilePath)
        loadData()
    }
        // Do any additional setup after loading the view, typically from a nib.
    
    
    //MARK DataSource Methods here
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var array = [Item]()
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        cell.textLabel?.text = array[indexPath.row].title
        
        cell.accessoryType = array[indexPath.row].done ? .checkmark : .none
        
    return cell
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    //MARK Delegate Methods here
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Select wurde ausgeführt")
        
        array[indexPath.row].done = !array[indexPath.row].done
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        saveData()
    }
    //MARK Add-Item-Button Action
    
    @IBAction func addItemButton(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Got something to do?", message: "Fill in a new task.", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            
            var newItem = Item()
            newItem.title = textfield.text!
            
            self.array.append(newItem)
            
            self.saveData()
            
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Create a new task"
            textfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    
    func saveData() {
        let encoder = PropertyListEncoder()
        
        do {let data = try encoder.encode(array)
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Encoding error")
        }
    }
    
    func loadData() {
        print("decodeing ausgelöst")
       if let data = try? Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do{
               array = try decoder.decode([Item].self, from: data)
            } catch {
                print("error decoding array")
            }
            
        }
        
    }
    
}

