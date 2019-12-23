//
//  LocationTableViewController.swift
//  Minhas Viagens
//
//  Created by César  Ferreira on 23/12/19.
//  Copyright © 2019 César  Ferreira. All rights reserved.
//

import UIKit

class LocationTableViewController: UITableViewController {

    var listTravels: [Dictionary<String, String>] = []
    var travelManager: TravelUserDefaults?
    var navigationControllerPage = "add"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        travelManager = TravelUserDefaults()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationControllerPage = "add"
        updateList()
    }
    
    private func updateList() {
        listTravels = travelManager?.list() ?? []
        tableView.reloadData()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listTravels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let travel = listTravels[indexPath.row]["local"]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "item_travel", for: indexPath)
        
        cell.textLabel?.text = travel

        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if ( editingStyle == UITableViewCell.EditingStyle.delete ) {
            
            travelManager?.remove(index: indexPath.row)
            updateList()
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationControllerPage = "detail"
        performSegue(withIdentifier: "detail", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detail") {
            let viewControllerDestino = segue.destination as! ViewController
            
            if (self.navigationControllerPage == "detail") {
                if let getIndex = sender {
                    
                    let index = getIndex as! Int
                    viewControllerDestino.travel = listTravels[ index ]
                    viewControllerDestino.indexSelected = index
                    
                }
            } else {
                viewControllerDestino.travel = [:]
                viewControllerDestino.indexSelected = -1
            }
        }
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

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
