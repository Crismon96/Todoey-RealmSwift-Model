//
//  ViewController.swift
//  Todoey
//
//  Created by Christoph Griehl on 08.03.19.
//  Copyright © 2019 apparillo. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
        loadData()
    }
        // Do any additional setup after loading the view, typically from a nib.
    
    
    //MARK DataSource Methods here
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    var array = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
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
            
            
            var newItem = Item(context: self.context)
            newItem.title = textfield.text!
            newItem.done = false
            
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
        
        do { try context.save()
        }
        catch { print("error saving context \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData() {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        do {
         array = try context.fetch(request)
        }
        catch {
            print("error loadData: \(error)")
        }
        

    }
}

extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "title CONTAINS %@", searchBar.text!)
        
        request.predicate = predicate
        
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        do {
            array = try context.fetch(request)
    }
        catch {
            print("Error searchBar: \(error)")
        }
        tableView.reloadData()
}
}
