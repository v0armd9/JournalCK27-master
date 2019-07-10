//
//  EntriesTableViewController.swift
//  JournalCK27
//
//  Created by RYAN GREENBURG on 7/9/19.
//  Copyright © 2019 RYAN GREENBURG. All rights reserved.
//

import UIKit

class EntriesTableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        EntryController.shared.fetchEntries { (success) in
            // handle
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        NotificationCenter.default.addObserver(self, selector: #selector(updateViews), name: EntryController.shared.entriesWereUpdatedNotification, object: nil)
    }
    
    @IBAction func addButtonTapped(_ sender: Any) {
        
    }
    
    @objc func updateViews() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toEntryDetailVC" {
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            let destinationVC = segue.destination as? EntryDetailViewController
            let entry = EntryController.shared.entries[index]
            destinationVC?.entry = entry
        }
    }
}

extension EntriesTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EntryController.shared.entries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell", for: indexPath)
        
        let entry = EntryController.shared.entries[indexPath.row]
        
        cell.textLabel?.text = entry.title
        cell.detailTextLabel?.text = entry.timestamp.formatDate()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let entry = EntryController.shared.entries[indexPath.row]
            let database = CloudKitController.shared.privateDB
            
            EntryController.shared.delete(entry: entry) { (success) in
                if success {
                    print("delete was successful")
                }
            }
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
