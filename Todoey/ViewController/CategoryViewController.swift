//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Christoph Griehl on 27.04.19.
//  Copyright © 2019 apparillo. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        print("started sucessfully")
    }
        //MARK: TableView Data Source Methods
        var catArray = [Category]()
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
            
            cell.textLabel?.text = catArray[indexPath.row].name
            
            return cell
        }
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return catArray.count
        }
        //MARK: Data Manipulation Mehtods
    func saveData() {
        do {
            try context.save()
        }
        catch {
            print("error saving data \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadData(){
        let request : NSFetchRequest<Category> = Category.fetchRequest()
        do {
            catArray = try context.fetch(request)
            print("loaded data sucessfully")
        }
        catch {
            print("error loading data \(error)")
        }
    }
        //MARK: ADD New Category
        
    @IBAction func addCategory(_ sender: UIBarButtonItem) {
        var textfield = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "Create a new Assignment", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            var newCategory = Category(context: self.context)
            newCategory.name = textfield.text!
            
            self.catArray.append(newCategory)
            print("bis zu save data wurde ausgeführt")
            self.saveData()
            self.tableView.reloadData()
        }
        alert.addTextField { (alertTextfield) in
            alertTextfield.placeholder = "Fill in Category"
            textfield = alertTextfield
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: Delegate Method here
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVC.selectedCategory = catArray[indexPath.row]
        }
    }
        
    
}
