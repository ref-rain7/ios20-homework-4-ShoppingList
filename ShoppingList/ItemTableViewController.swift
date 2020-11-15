//
//  ItemTableViewController.swift
//  ShoppingList
//
//  Created by zero on 2020/11/15.
//

import UIKit

class ItemTableViewController: UITableViewController {

    var items = [Item]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItem = self.editButtonItem
        if let savedItem = loadItems() {
            items += savedItem
        }
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let id = "ItemTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: id, for: indexPath) as? ItemTableViewCell else {
            fatalError("The dequeued cell is not an instance of ItemTableViewCell.")
        }
        let item = items[indexPath.row]
        cell.nameLabel.text = item.name
        cell.photoImageView.image = item.photo
        cell.ratingControl.rating = item.rating
        cell.commentLabel.text = item.comment
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            items.remove(at: indexPath.row)
            saveItems()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

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

    // MARK: - Navigation
    @IBAction func unuwindToTable(sender: UIStoryboardSegue) {
        guard let sourceViewController = sender.source as? ItemViewController else {
            return
        }
        guard let item = sourceViewController.item else {
            return
        }
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            items[selectedIndexPath.row] = item
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: items.count, section: 0)
            items.append(item)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
        saveItems()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        

        if let selectedCell = sender as? ItemTableViewCell {
            guard let itemDetailViewController = segue.destination as? ItemViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }

            let selectedItem = items[indexPath.row]
            itemDetailViewController.item = selectedItem
        } else {
            segue.destination.navigationItem.title = "add"
        }
    }
    
    
    // MARK: save and load
    func saveItems() {
        do {
            let saveData = try NSKeyedArchiver.archivedData(withRootObject: items, requiringSecureCoding: true)
            try saveData.write(to: Item.ArchiveURL)
            
        } catch {
            print(error)
        }
    }
    
    func loadItems() -> [Item]? {
        do {
            let data = try Data(contentsOf: Item.ArchiveURL)
            return try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? [Item]
        } catch {
            print(error)
            return nil
        }
    }
}
