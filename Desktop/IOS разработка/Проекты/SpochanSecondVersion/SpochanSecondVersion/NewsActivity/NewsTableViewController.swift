//
//  NewsTableViewController.swift
//  SpochanSecondVersion
//
//  Created by Admin on 08.03.2021.
//

import UIKit
import Firebase

struct newNote {
    let newsTitle : String!
    let newsDescription : String!
}

class NewsTableViewController: UITableViewController {
    
    
    var newNotes = [newNote]()
    let db = Firestore.firestore()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db.collection("NewsRussia").addSnapshotListener {querySnapshot, err in
            if let error = err {
                print("Тоби пизда        \(error)")
                //handler([])
            } else { //типо у нас все без ошибок загрузилось и все хорошо
                //handler(appUser.build(from: querySnapshot?.documents ?? []))
                
                //тут я считаю надо полностью списывать с сайта https://medium.com/dev-genius/display-firebase-firestore-data-inside-uitableview-e838f4213689 и потом брать и переделывать под свое, но изначально все целиком взять оттуда
                
                let newsTitle = querySnapshot?.value(forKey: "newsTitle") as! String
                let newsDescription = querySnapshot?.value(forKey: "newsDescription") as! String
                
                self.newNotes.insert(newNote(newsTitle: newsTitle, newsDescription: newsDescription), at: 0)
                self.tableView.reloadData()
                
            }
        }
        
        
    

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return newNotes.count
//    }
    

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newNotes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "newsCell")
        
        let label1 = cell?.viewWithTag(1) as! UILabel //Tag 1 выставляем в настройках каждой надписи
        label1.text = newNotes[indexPath.row].newsTitle
        print("ПИЗДЕЦ \(String(describing: newNotes[indexPath.row].newsTitle))")

        let label2 = cell?.viewWithTag(2) as! UILabel
        label2.text = newNotes[indexPath.row].newsDescription
        print("ПИЗДЕЦ \(String(describing: newNotes[indexPath.row].newsDescription))")

        return cell!
    }
    
//    //остальные настройки ячейки
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "CityTableViewCell", for: indexPath) as! CityTableViewCell
//        let city = citiesByCountry[indexPath.section][indexPath.row]
//        cell.update(name: city.name, image: city.image)
//        return cell
//    }
    

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
