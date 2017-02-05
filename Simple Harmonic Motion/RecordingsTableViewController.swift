//
//  RecordingsTableViewController.swift
//  Simple Harmonic Motion
//
//  Created by Xander Lewis on 03/02/2017.
//  Copyright © 2017 Xander Lewis. All rights reserved.
//

import UIKit

class RecordingsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var recordings: [Recording] = []
    var archiver: RecordingsArchiveManager!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        archiver = RecordingsArchiveManager()
        
        // Be notified when app colour scheme changes
        NotificationCenter.default.addObserver(self, selector: #selector(updateColours), name: AppColourScheme.changed, object: nil)
        
        updateColours()
    }
    
    func loadRecordings() {
        recordings = archiver.getRecordings().reversed()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        loadRecordings()
        
        let controller = tabBarController as? TabBarController
        controller?.clearNewRecordings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateColours() {
        view.backgroundColor = AppColourScheme.shared.colourForTableViewBackground()
        titleLabel.textColor = AppColourScheme.shared.colourForTableViewText()
        tableView.backgroundColor = AppColourScheme.shared.colourForTableViewBackground()
        tableView.separatorColor = AppColourScheme.shared.colourForTableViewSeparator()
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recordings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "recordingCell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "recordingCell")
        }
        
        cell?.contentView.backgroundColor = AppColourScheme.shared.colourForTableViewCellBackground()
        cell?.textLabel?.textColor = AppColourScheme.shared.colourForTableViewText()
        cell?.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        cell?.textLabel?.text = recordings[indexPath.row].title
        
        return cell!
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Remove recording
            recordings.remove(at: indexPath.row)
            
            // Update stored recordings
            archiver.replace(withNewRecordings: recordings.reversed())
            
            // Remove row from table
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Export data
        let csvGenerator = CSVGenerator(fromBodyDatasets: recordings[indexPath.row].bodyDatasets)
        let pathToData = csvGenerator.generateFile(withFilename: "simple-harmonic-motion.csv")
        
        // Allow user to send the data somewhere
        let vc = UIActivityViewController(activityItems: [pathToData], applicationActivities: [])
        
        vc.excludedActivityTypes = [.postToTwitter, .postToWeibo, .postToFlickr, .postToFacebook, .postToVimeo]
        
        vc.popoverPresentationController?.sourceView = tableView
        vc.popoverPresentationController?.sourceRect = CGRect(x: tableView.frame.width / 3, y: tableView.rowHeight * CGFloat(indexPath.row) + tableView.rowHeight / 2, width: 1, height: 1)
        
        view?.window?.rootViewController?.present(vc, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteButton = UITableViewRowAction(style: .default, title: "Delete") { (action, indexPath) in
            self.tableView.dataSource?.tableView!(self.tableView, commit: .delete, forRowAt: indexPath)
            return
        }
        
        deleteButton.backgroundColor = UIColor(red:1.00, green:0.00, blue:0.36, alpha:1.0)
        
        return [deleteButton]
    }
}
